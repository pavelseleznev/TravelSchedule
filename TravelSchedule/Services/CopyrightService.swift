//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/21/25.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.Copyright

enum ResponseFormat: String {
    case json, xml
}

protocol CopyrightProtocol: Sendable {
    func getCopyright(format: ResponseFormat) async throws -> Copyright
}

actor CopyrightService: CopyrightProtocol {
    private let client: Client
    
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCopyright(format: ResponseFormat) async throws -> Copyright {
        let response = try await client.getCopyright(query: .init(
            apikey: apikey,
            format: format.rawValue
        ))
        return try response.ok.body.json
    }
}
