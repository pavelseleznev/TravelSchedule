//
//  StoriesCell.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct StoriesCell: View {
    var stories: Stories
    let imageHeight: Double = 140
    let imageWidth: Double = 92
    var body: some View {
        VStack(alignment: .leading) {
            Image(stories.previewImage)
                .resizable()
                .cornerRadius(16)
                .frame(width: imageWidth, height: imageHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blueUniversal, lineWidth: 4)
                )
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    StoriesCell(stories: Stories(
        previewImage: "ModernSentinelsPreview",
        bigImage: "ModernSentinelsBig")
    )
}
