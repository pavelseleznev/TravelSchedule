//
//  StationViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class RailwayStationViewModel {
    
    // MARK: - Public State
    private(set) var railwayStations: [RailwayStation] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    private(set) var searchText: String = ""
    
    // MARK: - Dependencies
    private let networkClient = NetworkClient.shared
    private let cacheManager = CacheManager.shared
    
    // MARK: - Computed
    var filteredStations: [RailwayStation] {
        guard !searchText.isEmpty else { return railwayStations }
        return railwayStations.filter { station in
            station.name.localizedCaseInsensitiveContains(searchText)
            || station.cityTitle?.localizedCaseInsensitiveContains(searchText) == true
            || station.regionTitle?.localizedCaseInsensitiveContains(searchText) == true
        }
        .sorted { lhs, rhs in
            lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
    
    // MARK: - Public API
    func loadStationsForCity(_ city: City) async {
        if let cachedStations = cacheManager.getCachedStations(for: city.cityName) {
            railwayStations = cachedStations
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient().getAllStations()
            let loadedStations = processStationsResponseForCity(response, cityName: city.cityName)
            railwayStations = loadedStations
            cacheManager.cacheStations(loadedStations, for: city.cityName)
            isLoading = false
        } catch {
            errorMessage = "Failed to load stations for city \(city.cityName): \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func searchText(query: String) {
        searchText = query
    }
    
    // MARK: - Response Processing
    private func processStationsResponseForCity(_ response: Components.Schemas.AllStationsResponse, cityName: String) -> [RailwayStation] {
        guard let countries = response.countries else { return [] }
        var cityStations: [RailwayStation] = []
        let target = cityName.lowercased()
        
        for country in countries {
            guard let countryTitle = country.title,
                  countryTitle.contains("Россия") || countryTitle.contains("РФ") || countryTitle.contains("Russia"),
                  let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard let settlementTitle = settlement.title,
                          settlementTitle.lowercased() == target,
                          let stations = settlement.stations else { continue }

                    for station in stations {
                        guard let stationTitle = station.title else { continue }
                        // Filter only train/suburban and only real stations (exclude platforms/stops)
                        let stationType = station.station_type?.lowercased() ?? ""
                        let transportType = station.transport_type?.lowercased() ?? ""
                        let isRealStation = stationType == "station" || stationType == "train_station"
                        let isRail = transportType == "train" || transportType == "suburban"
                        let titleIsPlatform = stationTitle.lowercased().hasPrefix("платформа")
                            || stationTitle.lowercased().hasPrefix("платф.")
                            || stationTitle.lowercased().hasPrefix("ост.")
                            || stationTitle.lowercased().hasPrefix("остановка")
                        guard isRealStation && isRail && !titleIsPlatform else { continue }

                        let stationCode = station.code ?? station.codes?.yandex_code

                        let railwayStation = RailwayStation(
                            name: stationTitle,
                            stationCode: stationCode,
                            cityTitle: settlementTitle,
                            regionTitle: region.title,
                            lat: station.lat,
                            lng: station.lng,
                            transportType: station.transport_type
                        )
                        cityStations.append(railwayStation)
                    }
                }
            }
        }
        return cityStations.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
