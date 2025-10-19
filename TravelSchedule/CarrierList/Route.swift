//
//  Route.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/16/25.
//

import Foundation

// MARK: - Model (Sendable conformance)
struct Route: Identifiable, Sendable {
    let id: UUID
    let from: String
    let to: String
    let departure: String
    let arrival: String
    let duration: String
    let carrier: String?
    let transportType: String
    let price: String?
    
    init(
        id: UUID = UUID(),
        from: String,
        to: String,
        departure: String,
        arrival: String,
        duration: String,
        carrier: String? = nil,
        transportType: String,
        price: String? = nil
    ) {
        self.id = id
        self.from = from
        self.to = to
        self.departure = departure
        self.arrival = arrival
        self.duration = duration
        self.carrier = carrier
        self.transportType = transportType
        self.price = price
    }
}
