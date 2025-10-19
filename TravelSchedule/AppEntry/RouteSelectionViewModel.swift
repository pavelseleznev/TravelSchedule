//
//  RouteSelectionViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/12/25.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class RouteSelectionViewModel {
    
    // MARK: - Dependencies
    private let networkClient = NetworkClient.shared
    
    // MARK: - UI / Navigation State
    var selectedTabIndex: Int = 0
    var navigationPath = NavigationPath()
    var hasFinishedSplash = false
    
    // MARK: - Selection State
    var fromCity: City?
    var fromStation: RailwayStation?
    var toCity: City?
    var toStation: RailwayStation?
    private var selectedDate: Date = Date()
    
    // MARK: - Data State
    private var allStations: [RailwayStation] = []
    
    // MARK: - Loading / Error State
    var errorMessage: String?
    private var isLoading: Bool = false
    
    // MARK: - Computed / Derived
    var isFindButtonEnabled: Bool {
        fromStation != nil && toStation != nil
    }
    
    var fromText: String {
        if let city = fromCity, let station = fromStation {
            return "\(city.cityName) (\(station.name))"
        } else if let city = fromCity {
            return city.cityName
        }
        return String(localized: "from_placeholder")
    }
    
    var toText: String {
        if let city = toCity, let station = toStation {
            return "\(city.cityName) (\(station.name))"
        } else if let city = toCity {
            return city.cityName
        }
        return String(localized: "to_placeholder")
    }
    
    private var formattedDate: String {
        Self.dateFormatter.string(from: selectedDate)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Selection Mutations
    func swapCities() {
        let oldFromCity = fromCity
        let oldFromStation = fromStation
        fromCity = toCity
        fromStation = toStation
        toCity = oldFromCity
        toStation = oldFromStation
    }
    
    // MARK: - Networking
    private func setLoading(_ loading: Bool) {
        isLoading = loading
    }
    
    private func setError(_ message: String?) {
        errorMessage = message
    }
    
    private func runNetwork<T>(_ work: @escaping () async throws -> T) async throws -> T {
        setLoading(true)
        setError(nil)
        defer { setLoading(false) }
        return try await work()
    }
    
    private func loadAllStations() async {
        do {
            let response: Components.Schemas.AllStationsResponse = try await runNetwork {
                try await self.networkClient().getAllStations()
            }
            allStations = processStationsResponse(response)
        } catch {
            setError("Failed to load stations: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Response Processing
    private func processStationsResponse(_ response: Components.Schemas.AllStationsResponse) -> [RailwayStation] {
        return []
    }
}
