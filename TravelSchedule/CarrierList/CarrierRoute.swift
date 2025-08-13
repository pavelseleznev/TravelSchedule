//
//  CarrierRoute.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

struct CarrierRoute: Identifiable, Hashable {
    var id = UUID()
    var carrierName: String
    var date: String
    var departureTime: String
    var arrivalTime: String
    var duration: String
    var withTransfer: Bool
    var carrierImage: String
    var note: String?
}
