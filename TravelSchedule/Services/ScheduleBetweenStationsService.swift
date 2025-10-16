//
//  ScheduleBetweenStationsService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/21/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsProtocol: Sendable {
    func getScheduleBetweenStations(from: String, to: String) async throws -> ScheduleBetweenStations
}

actor ScheduleBetweenStationsService: ScheduleBetweenStationsProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to
        ))
        return try response.ok.body.json
    }
}
