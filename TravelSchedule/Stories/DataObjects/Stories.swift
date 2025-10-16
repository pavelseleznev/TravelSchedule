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
}
