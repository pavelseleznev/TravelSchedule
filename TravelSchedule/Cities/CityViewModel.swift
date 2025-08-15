//
//  CitiesViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation

final class CityViewModel: ObservableObject {
    @Published var cities: [City]
    
    init()  {
        self.cities = [
            City(cityName: "Москва"),
            City(cityName: "Санкт-Петербург"),
            City(cityName: "Сочи"),
            City(cityName: "Горный воздух"),
            City(cityName: "Краснодар"),
            City(cityName: "Казань"),
            City(cityName: "Омск"),
        ]
    }
}
