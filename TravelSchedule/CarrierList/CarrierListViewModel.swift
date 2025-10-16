//
//  CarrierRouteViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class CarrierListViewModel {
    
    // MARK: - Public State
    var selectedPeriods: Set<TimePeriod> = []
    var showWithTransfer: Bool? = nil
    var routes: [CarrierRoute] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var filteredRoutes: [CarrierRoute] {
        routes.filter { route in
            let isPeriodMatch: Bool = {
                guard !selectedPeriods.isEmpty else { return true }
                let comps = route.departureTime.split(separator: ":").compactMap { Int(String($0)) }
                guard let hour = comps.first else { return false }
                return selectedPeriods.contains { period in
                    switch period {
                    case .morning: return hour >= 6 && hour < 12
                    case .day:     return hour >= 12 && hour < 18
                    case .evening: return hour >= 18 && hour < 24
                    case .night:   return hour >= 0  && hour < 6
                    }
                }
            }()
            
            let isTransferMatch: Bool = {
                guard let show = showWithTransfer else { return true }
                return route.withTransfer == show
            }()
            
            return isPeriodMatch && isTransferMatch
        }
        .sorted { $0.departureTime < $1.departureTime }
    }
    
    // MARK: - Dependencies
    private let networkClient = NetworkClient.shared
    private let cacheManager = CacheManager.shared
    
    func loadSchedule(fromStation: String, toStation: String) async {
        // Synchronous pre-check (no await) so we can return early
        guard !fromStation.isEmpty && !toStation.isEmpty else {
            self.errorMessage = "Не указаны станции отправления или прибытия"
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        
        // Try cache on calling thread; update UI state on main actor
        if let cachedRoutes = cacheManager.getCachedSchedule(from: fromStation, to: toStation, date: dateString) {
            self.routes = cachedRoutes
            self.isLoading = false
            self.errorMessage = nil
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await networkClient().getScheduleBetweenStations(
                from: fromStation,
                to: toStation,
                date: dateString
            )
            
            let loadedRoutes = self.processScheduleResponse(response)
            
            self.routes = loadedRoutes
            self.cacheManager.cacheSchedule(loadedRoutes, from: fromStation, to: toStation, date: dateString)
            self.isLoading = false
            self.errorMessage = nil
        } catch {
            let message = userFacingErrorMessage(from: error)
            if self.isNotFound404(error) {
                self.routes = []
                self.errorMessage = nil
            } else {
                self.errorMessage = message
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Private Methods
    /// Detects OpenAPI undocumented 404 (or similar) to treat as "no options" case
    private func isNotFound404(_ error: Error) -> Bool {
        let desc = String(describing: error)
        return desc.contains("undocumented(statusCode: 404") || desc.contains("unexpectedStatusCode(404")
    }
    
    /// Maps low-level OpenAPI errors to user-facing messages.
    private func userFacingErrorMessage(from error: Error) -> String {
        let desc = String(describing: error)
        // Handle undocumented 404 payloads produced by OpenAPI client
        if desc.contains("undocumented(statusCode: 404") || desc.contains("unexpectedStatusCode(404") {
            return "Маршрут не найден для выбранных параметров. Попробуйте изменить дату/время или пункт отправления/прибытия."
        }
        // Common connectivity wording
        if desc.localizedCaseInsensitiveContains("timed out") ||
            desc.localizedCaseInsensitiveContains("offline") ||
            desc.localizedCaseInsensitiveContains("The Internet connection appears to be offline") {
            return "Нет соединения с сервером. Проверьте интернет и попробуйте снова."
        }
        return "Ошибка загрузки расписания. Повторите попытку позже."
    }
    
    private func processScheduleResponse(_ response: Components.Schemas.Segments) -> [CarrierRoute] {
        guard let segments = response.segments else { return [] }
        
        var scheduleRoutes: [CarrierRoute] = []
        
        for segment in segments {
            guard let departure = segment.departure,
                  let arrival = segment.arrival else { continue }
            let thread = segment.thread
            
            // Prefer the carrier title of a TRAIN leg if available (multi-leg cases),
            // otherwise fall back to the current single-thread carrier or generic name.
            let carrierName: String = {
                // Base fallback: keep existing logic (single-thread carrier or generic name)
                let base = nonEmpty(thread?.carrier?.title) ?? "Неизвестный перевозчик"
                
                // If details are present, try to find a train leg and use its carrier title
                if let items = segment.details {
                    for item in items {
                        if let t = item.thread, t.transport_type == "train" {
                            if let name = nonEmpty(t.carrier?.title) { return name }
                        }
                    }
                }
                return base
            }()
            
            let departureTime = formatTime(departure)
            let arrivalTime = formatTime(arrival)
            
            let duration = calculateDuration(from: departure, to: arrival)
            
            let date = formatDate(departure)
            
            let withTransfer = segment.has_transfers ?? false
            
            let carrierLogo = thread?.carrier?.logo
            
            let (carrierImage, carrierImageURL): (String, String?) = {
                guard let logo = nonEmpty(carrierLogo) else {
                    return ("train.side.front.car", nil)
                }
                // If the logo ends with .svg → treat as unusable for AsyncImageView
                if logo.lowercased().hasSuffix(".svg") {
                    return ("train.side.front.car", nil)
                } else {
                    return ("", logo)
                }
            }()
            
            let email = nonEmpty(thread?.carrier?.email)
            let phone = nonEmpty(thread?.carrier?.phone)
            // Build a more informative note for transfer cases: "С пересадкой (Город/поселение)"
            // Priority: details.transfer_point -> transfers[0] -> final destination station title
            let transferPlace: String? = {
                guard withTransfer else { return nil }
                // 1) details[].transfer_point (prefer the item flagged as transfer)
                if let items = segment.details {
                    if let transferPoint = items.first(where: { $0.is_transfer == true })?.transfer_point {
                        if let name = nonEmpty(transferPoint.short_title) ?? nonEmpty(transferPoint.popular_title) ?? nonEmpty(transferPoint.title) {
                            return name
                        }
                    }
                }
                // 2) transfers[0]
                if let first = segment.transfers?.first {
                    if let name = nonEmpty(first.short_title) ?? nonEmpty(first.popular_title) ?? nonEmpty(first.title) {
                        return name
                    }
                }
                // 3) fallback to overall destination (less accurate, but better than nothing)
                if let station = segment.to {
                    if let name = nonEmpty(station.short_title) ?? nonEmpty(station.popular_title) ?? nonEmpty(station.title) {
                        return name
                    }
                }
                return nil
            }()
            
            let noteText: String? = {
                guard withTransfer else { return nil }
                if let place = transferPlace {
                    return "С пересадкой (\(place))"
                } else {
                    return "С пересадкой"
                }
            }()
            
            let route = CarrierRoute(
                carrierName: carrierName,
                date: date,
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                duration: duration,
                withTransfer: withTransfer,
                carrierImage: carrierImage,
                carrierImageURL: carrierImageURL,
                note: noteText,
                email: email,
                phone: phone
            )
            scheduleRoutes.append(route)
        }
        
        return scheduleRoutes.sorted { $0.departureTime < $1.departureTime }
    }
    
    private func formatTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
    
    private func calculateDuration(from departure: Date, to arrival: Date) -> String {
        let duration = arrival.timeIntervalSince(departure)
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours) ч \(minutes) мин"
        } else if hours > 0 {
            return "\(hours) ч"
        } else {
            return "\(minutes) мин"
        }
    }
    
    private func nonEmpty(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? nil : trimmed
    }
}
