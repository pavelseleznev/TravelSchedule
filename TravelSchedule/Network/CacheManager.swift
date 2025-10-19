//
//  CacheManager.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/13/25.
//

import Foundation

@MainActor
@Observable
final class CacheManager {
    
    // MARK: - Singleton
    static let shared = CacheManager()
    
    // MARK: - Published Caches
    private var citiesCache: [City] = []
    private var stationsCache: [String: [RailwayStation]] = [:]
    private var scheduleCache: [String: [CarrierRoute]] = [:]
    
    // MARK: - Timestamps & Config
    private var citiesCacheTimestamp: Date?
    private var stationsCacheTimestamp: [String: Date] = [:]
    private var scheduleCacheTimestamp: [String: Date] = [:]
    
    private let cacheExpirationTime: TimeInterval = 30 * 60
    private let maxScheduleCacheSize = 50
    
    // MARK: - Cities Cache
    func getCachedCities() -> [City]? {
        guard let timestamp = citiesCacheTimestamp,
              !isCacheExpired(timestamp: timestamp) else {
            return nil
        }
        
        return citiesCache
    }
    
    func cacheCities(_ cities: [City]) {
        citiesCache = cities
        citiesCacheTimestamp = Date()
    }
    
    // MARK: - Stations Cache
    func getCachedStations(for cityName: String) -> [RailwayStation]? {
        guard let timestamp = stationsCacheTimestamp[cityName],
              !isCacheExpired(timestamp: timestamp),
              let stations = stationsCache[cityName] else {
            return nil
        }
        
        return stations
    }
    
    func cacheStations(_ stations: [RailwayStation], for cityName: String) {
        stationsCache[cityName] = stations
        stationsCacheTimestamp[cityName] = Date()
    }
    
    // MARK: - Schedule Cache
    func getCachedSchedule(from: String, to: String, date: String) -> [CarrierRoute]? {
        let key = "\(from)_\(to)_\(date)"
        
        guard let timestamp = scheduleCacheTimestamp[key],
              !isCacheExpired(timestamp: timestamp),
              let routes = scheduleCache[key] else {
            return nil
        }
        return routes
    }
    
    func cacheSchedule(_ routes: [CarrierRoute], from: String, to: String, date: String) {
        let key = "\(from)_\(to)_\(date)"
        
        if scheduleCache.count >= maxScheduleCacheSize {
            clearOldestScheduleCache()
        }
        
        scheduleCache[key] = routes
        scheduleCacheTimestamp[key] = Date()
    }
    
    // MARK: - Cache Utilities
    private func isCacheExpired(timestamp: Date) -> Bool {
        Date().timeIntervalSince(timestamp) > cacheExpirationTime
    }
    
    private func clearOldestScheduleCache() {
        guard !scheduleCacheTimestamp.isEmpty else { return }
        
        let oldestKey = scheduleCacheTimestamp.min { $0.value < $1.value}?.key
        
        if let keyToRemove = oldestKey {
            scheduleCache.removeValue(forKey: keyToRemove)
            scheduleCacheTimestamp.removeValue(forKey: keyToRemove)
        }
    }
}
