//
//  StationViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation

final class RailwayStationViewModel: ObservableObject {
    @Published var railwayStations: [RailwayStation]
    
    init() {
        self.railwayStations = [
            RailwayStation(name: "Киевский вокзал"),
            RailwayStation(name: "Курский вокзал"),
            RailwayStation(name: "Ярославский вокзал"),
            RailwayStation(name: "Белорусский вокзал"),
            RailwayStation(name: "Савеловский вокзал"),
            RailwayStation(name: "Ленинградский вокзал")
        ]
    }
}
