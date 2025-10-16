//
//  CarrierDetailsViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/15/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class CarrierDetailsViewModel {
    var route: CarrierRoute
    
    init(route: CarrierRoute) {
        self.route = route
    }
}
