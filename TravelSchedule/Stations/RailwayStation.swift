//
//  RailwayStation.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

struct RailwayStation: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let stationCode: String?
    let cityTitle: String?
    let regionTitle: String?
    let lat: Double?
    let lng: Double?
    let transportType: String?
    
    init(
        name: String,
        stationCode: String? = nil,
        cityTitle: String? = nil,
        regionTitle: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil,
        transportType: String? = nil
    ) {
        self.name = name
        self.stationCode = stationCode
        self.cityTitle = cityTitle
        self.regionTitle = regionTitle
        self.lat = lat
        self.lng = lng
        self.transportType = transportType
    }
}
