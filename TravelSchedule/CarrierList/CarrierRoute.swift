//
//  CarrierRoute.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

struct CarrierRoute: Identifiable, Hashable {
    let id = UUID()
    let carrierName: String
    let date: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let withTransfer: Bool
    let carrierImage: String
    let note: String?
    let email: String?
    let phone: String?
}
