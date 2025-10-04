//
//  StoriesCell.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct StoriesCell: View {
    
    // MARK: - Properties & Environment
    var stories: Stories
    private let imageHeight: Double = 140
    private let imageWidth: Double = 92
    @EnvironmentObject private var viewModel: StoriesViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Image(stories.previewImage)
                .resizable()
                .cornerRadius(16)
                .frame(width: imageWidth, height: imageHeight)
                .overlay(
                    Text("Text Text Text Text Text Text Text")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .frame(width: 76, height: 45)
                        .offset(x: 6, y:  83)
                    , alignment: .topLeading)
                .opacity(viewModel.isStoryViewed(stories) ? 0.5 : 1.0)
                .overlay(
                    viewModel.isStoryViewed(stories)
                    ? RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 0)
                    : RoundedRectangle(cornerRadius: 16).stroke(Color.blue, lineWidth: 4)
                )
        }
        .padding(.horizontal, 4)
        .frame(width: imageWidth + 8, height: imageHeight)
        .onTapGesture {
            if let index = viewModel.story.firstIndex(where: { $0.id == stories.id }) {
                viewModel.selectStory(at: index)
            }
        }
    }
}

#Preview {
    StoriesCell(stories: Stories(
        previewImage: "ModernSentinelsPreview",
        images: ["ModernSentinelsBig"]))
    .environmentObject(StoriesViewModel())
}
