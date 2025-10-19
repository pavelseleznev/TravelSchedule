//
//  City.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

struct City: Identifiable, Hashable, Sendable {
    let id = UUID()
    let cityName: String
    let regionTitle: String?
    let lat: Double?
    let lng: Double?
    
    init(
        cityName: String,
        regionTitle: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil
    ) {
        self.cityName = cityName
        self.regionTitle = regionTitle
        self.lat = lat
        self.lng = lng
    }
}
