//
//  Destination.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

enum Destination: Hashable {
    case cities(isSelectingFrom: Bool)
    case stations(city: City, isSelectingFrom: Bool)
    case carriers(fromCity: City, fromStation: RailwayStation, toCity: City, toStation: RailwayStation)
    case filters(fromCity: City, fromStation: RailwayStation, toCity: City, toStation: RailwayStation)
}
