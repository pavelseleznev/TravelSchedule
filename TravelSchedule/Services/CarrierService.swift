//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/23/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierProtocol {
    func getCarrierInfo(code: String, system: String?) async throws -> CarrierResponse
}

final class CarrierService: CarrierProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String, system: String? = nil) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code,
            system: system,
            lang: "ru_RU",
            format: "json"
        ))
        return try response.ok.body.json
    }
}
