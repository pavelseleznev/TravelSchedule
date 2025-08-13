//
//  StoriesViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import Foundation

@Observable final class StoriesViewModel {
    private(set) var stories: [Stories]
    private(set) var showStoryView: Bool = false
    
    init() {
        self.stories = [
            Stories(previewImage: "TheLocomotiveEngineerPreview", bigImage: "TheLocomotiveEngineerBig"),
            Stories(previewImage: "ModernSentinelsPreview", bigImage: "ModernSentinelsBig"),
            Stories(previewImage: "JourneyThroughTheJunglePreview", bigImage: "JourneyThroughTheJungleBig"),
            Stories(previewImage: "QuietJourneyPreview", bigImage: "QuietJourneyBig"),
        ]
    }
}
