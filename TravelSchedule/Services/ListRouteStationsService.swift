//
//  ListRouteStationsService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/23/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.ThreadStationsResponse

protocol ListRouteStationsProtocol {
    func getRouteStations(uid: String) async throws -> RouteStations
}

final class ListRouteStationsService: ListRouteStationsProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String) async throws -> RouteStations {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid
        ))
        return try response.ok.body.json
    }
}
