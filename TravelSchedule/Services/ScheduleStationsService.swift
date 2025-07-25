//
//  ScheduleStationsService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/22/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleStations = Components.Schemas.ScheduleResponse

protocol ScheduleStationsProtocol {
    func getStationSchedule(stationCode: String) async throws -> ScheduleStations
}

final class ScheduleStationsService: ScheduleStationsProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(stationCode: String) async throws -> ScheduleStations {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: stationCode
        ))
        return try response.ok.body.json
    }
}
