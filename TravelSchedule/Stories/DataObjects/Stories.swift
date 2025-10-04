//
//  Stories.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct Stories: Identifiable, Hashable {
    let id = UUID()
    let previewImage: String
    let images: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private static func ==(lhs: Stories, rhs: Stories) -> Bool {
        lhs.id == rhs.id
    }
}
