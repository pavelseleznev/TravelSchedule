//
//  TimePeriod.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/13/25.
//

import Foundation

enum TimePeriod: String, CaseIterable, Hashable, Sendable {
    case morning
    case day
    case evening
    case night
    
    var localized: String {
        switch self {
        case .morning: return String(localized: "timeperiod.morning")
        case .day:     return String(localized: "timeperiod.day")
        case .evening: return String(localized: "timeperiod.evening")
        case .night:   return String(localized: "timeperiod.night")
        }
    }
}
