//
//  CitiesViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class CityViewModel {
    
    // MARK: - Public Properties
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Private Properties
    private var cities: [City] = []
    private var searchText: String = ""
    private let networkClient = NetworkClient.shared
    private let cacheManager = CacheManager.shared
    
    // MARK: - Computed Properties
    var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        }
        
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return cities.filter { cities in
            let cityName = cities.cityName.lowercased()
            let regionName = cities.regionTitle?.lowercased() ?? ""
            
            if cityName.hasPrefix(trimmedSearch) { return true }
            if cityName.contains(trimmedSearch) { return true }
            if regionName.contains(trimmedSearch) { return true }
            return false
        }.sorted { city1, city2 in
            let city1Name = city1.cityName.lowercased()
            let city2Name = city2.cityName.lowercased()
            
            let city1StartsWithSearch = city1Name.hasPrefix(trimmedSearch)
            let city2StartsWithSearch = city2Name.hasPrefix(trimmedSearch)
            
            if city1StartsWithSearch && !city2StartsWithSearch {
                return true
            } else if !city1StartsWithSearch && city2StartsWithSearch {
                return false
            } else {
                return city1Name < city2Name
            }
        }
    }
    
    // MARK: - Public Methods
    func lookUpCity(query: String) {
        searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func loadAllCities() async {
        if let cached = cacheManager.getCachedCities() {
            cities = cached.filter { !$0.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient().getAllStations()
            let loaded = processAllStationsResponse(response)
            cities = loaded
            cacheManager.cacheCities(loaded)
            isLoading = false
        } catch {
            errorMessage = "Failed to load all cities: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // MARK: - Private Methods
    private func nonEmptyTrimmed(_ value: String?) -> String? {
        let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? nil : trimmed
    }
    
    private func loadCitiesByLocation(lat: Double, lng: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await networkClient().getNearestCity(lat: lat, lng: lng)
            self.cities = self.processCitiesResponse(response)
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load cities by location: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    private func processAllStationsResponse(_ response: Components.Schemas.AllStationsResponse) -> [City] {
        guard let countries = response.countries else { return [] }
        
        var uniqueCities: [String: City] = [:]
        
        for country in countries {
            guard let countryTitle = country.title,
                  countryTitle.contains("Россия") || countryTitle.contains("РФ") || countryTitle.contains("Russia"),
                  let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard let stations = settlement.stations else { continue }
                    guard let title = nonEmptyTrimmed(settlement.title) else { continue }
                    
                    let cityKey = title.lowercased()
                    
                    if uniqueCities[cityKey] == nil {
                        let firstStation = stations.first
                        uniqueCities[cityKey] = City(
                            cityName: title,
                            regionTitle: nonEmptyTrimmed(region.title),
                            lat: firstStation?.lat,
                            lng: firstStation?.lng
                        )
                    }
                }
            }
        }
        return Array(uniqueCities.values)
            .filter { !( $0.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ) }
            .sorted { $0.cityName < $1.cityName }
    }
    
    private func processCitiesResponse(_ response: Components.Schemas.NearestCityResponse) -> [City] {
        return []
    }
}
