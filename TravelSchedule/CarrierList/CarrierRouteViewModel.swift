//
//  CarrierRouteViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation

final class CarrierRouteViewModel: ObservableObject {
    @Published var routes: [CarrierRoute]
    @Published var selectedPeriods: Set<TimePeriod> = [] {
        didSet { applyFilters() }
    }
    @Published var showWithTransfer: Bool? {
        didSet { applyFilters() }
    }
    @Published var filteredRoutes: [CarrierRoute] = []
    
    init() {
        self.routes = [
            CarrierRoute(carrierName: "РЖД", date: "14 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RusRailwaysBrandIcon", note: "С пересадкой в Костроме", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
            CarrierRoute(carrierName: "ФГК", date: "15 января", departureTime: "01:15", arrivalTime: "09:00", duration: "9 часов", withTransfer: false, carrierImage: "FGKBrandIcon", note: nil, email: nil, phone: nil),
            CarrierRoute(carrierName: "Урал логистика", date: "16 января", departureTime: "12:30", arrivalTime: "21:00", duration: "9 часов", withTransfer: false, carrierImage: "UralLogisticsBrandIcon", note: nil, email: nil, phone: nil),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RusRailwaysBrandIcon", note: "С пересадкой в Костроме", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RusRailwaysBrandIcon", note: nil, email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RusRailwaysBrandIcon", note: nil, email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"),
            CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: false, carrierImage: "RusRailwaysBrandIcon", note: nil, email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71")
        ]
        self.filteredRoutes = routes
    }
    
    private func applyFilters() {
        filteredRoutes = routes.filter { route in
            let isPeriodMatch: Bool
            if selectedPeriods.isEmpty {
                isPeriodMatch = true
            } else {
                let components = route.departureTime.split(separator: ":").compactMap { Int($0) }
                guard let hour = components.first else {
                    return false
                }
                isPeriodMatch = selectedPeriods.contains { period in
                    switch period {
                    case .morning: return hour >= 6 && hour < 12
                    case .day: return hour >= 12 && hour < 18
                    case .evening: return hour >= 18 && hour < 24
                    case .night: return (hour >= 0 && hour < 6) || hour == 24
                    }
                }
            }
            
            let isTransferMatch: Bool
            if let showWithTransfer = showWithTransfer {
                isTransferMatch = route.withTransfer == showWithTransfer
            } else {
                isTransferMatch = true
            }
            
            return isPeriodMatch && isTransferMatch
        }
    }
}
