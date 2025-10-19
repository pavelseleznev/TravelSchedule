//
//  NetworkClientError.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/16/25.
//

import Foundation

// MARK: - Errors
enum NetworkClientError: Error, Sendable {
    case invalidServerURL
    case missingAPIKey
}
