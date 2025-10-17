//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/12/25.
//

import Foundation
import OpenAPIURLSession

// MARK: - NetworkClient actor (singleton)
actor NetworkClient: Sendable {
    
    @MainActor private static var cachedShared: NetworkClient?
    
    @MainActor
    static func shared() throws -> NetworkClient {
        if let instance = cachedShared { return instance }
        let instance = try NetworkClient()
        cachedShared = instance
        return instance
    }
    
    private let client: Client
    private let apiKey: String
    
    // Designated initializer throws on invalid config
    init() throws {
        guard let url = URL(string: "https://api.rasp.yandex.net") else {
            throw NetworkClientError.invalidServerURL
        }
        
        // Replace with secure key management in production
        let key = "6db1daa7-c560-4544-9088-1717e55fc4cf"
        guard !key.isEmpty else {
            throw NetworkClientError.missingAPIKey
        }
        
        self.client = Client(serverURL: url, transport: URLSessionTransport())
        self.apiKey = key
    }
    
    // MARK: - API methods (actor-isolated, concurrency-safe)
    func getAllStations() async throws -> Components.Schemas.AllStationsResponse {
        let response = try await client.getAllStations(query: .init(apikey: apiKey))
        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        return try JSONDecoder().decode(Components.Schemas.AllStationsResponse.self, from: fullData)
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> Components.Schemas.NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(apikey: apiKey, lat: lat, lng: lng))
        return try response.ok.body.json
    }
    
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int,
        stationTypes: String? = "station,train_station",
        transportTypes: String? = "train,suburban"
    ) async throws -> Components.Schemas.Stations {
        let response = try await client.getNearestStations(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng,
                distance: distance,
                station_types: stationTypes,
                transport_types: transportTypes
            )
        )
        return try response.ok.body.json
    }
    
    func getScheduleBetweenStations(from: String, to: String, date: String) async throws -> Components.Schemas.Segments {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                date: date,
                transfers: true
            )
        )
        return try response.ok.body.json
    }
    
    func getCarrierInfo(code: String) async throws -> Components.Schemas.CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apiKey, code: code))
        return try response.ok.body.json
    }
    
    func getStationSchedule(stationCode: String) async throws -> Components.Schemas.ScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(apikey: apiKey, station: stationCode))
        return try response.ok.body.json
    }
    
    func getRouteStations(uid: String) async throws -> Components.Schemas.ThreadStationsResponse {
        let response = try await client.getRouteStations(
            query: .init(apikey: apiKey,uid: uid))
        return try response.ok.body.json
    }
    
    func getCopyright(format: ResponseFormat = .json) async throws -> Components.Schemas.Copyright {
        let response = try await client.getCopyright(
            query: .init(apikey: apiKey,format: format.rawValue))
        return try response.ok.body.json
    }
}
