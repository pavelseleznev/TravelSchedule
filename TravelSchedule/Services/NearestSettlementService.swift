//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/23/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestSettlement = Components.Schemas.NearestCityResponse

protocol NearestSettlementProtocol: Sendable {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestSettlement
}

actor NearestSettlementService: NearestSettlementProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestSettlement {
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng
        ))
        return try response.ok.body.json
    }
}
