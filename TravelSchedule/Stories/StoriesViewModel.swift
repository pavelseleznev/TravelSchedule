//
//  StoriesViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI
import Combine
import Observation

@MainActor
@Observable
final class StoriesViewModel {
    
    // MARK: - Published Properties
    var story: [Stories]
    var showStoryView: Bool = false
    var currentStoryIndex: Int = 0
    var currentImageIndex: Int = 0
    var progress: CGFloat = 0.0
    private var viewedStories: Set<UUID> = []
    
    // MARK: - Timer Properties
    private var timer: Timer.TimerPublisher = Timer.publish(every: 0.05, on: .main, in: .common)
    private var cancellable: AnyCancellable?
    private let imageDuration: TimeInterval = 10.0
    
    // MARK: - Initialization
    init() {
        self.story = [
            Stories(previewImage: "TheLocomotiveEngineerPreview", images: ["TheLocomotiveEngineerBig", "SilentVigilBig"]),
            Stories(previewImage: "ModernSentinelsPreview", images: ["ModernSentinelsBig", "TheOfficerGazeBig"]),
            Stories(previewImage: "TheWeightOfSilencePreview", images: ["TheWeightOfSilenceBig", "ChasingTheIronHorseBig"]),
            Stories(previewImage: "SilentJourneyDayPreview", images: ["SilentJourneyDayBig", "SilentJourneyNightBig"]),
            Stories(previewImage: "JourneyThroughTheFrostedPeaksPreview", images: ["JourneyThroughTheFrostedPeaksBig", "WinterJourneyTheSteamExpressBig"]),
            Stories(previewImage: "JourneyThroughTheJunglePreview", images: ["JourneyThroughTheJungleBig", "VibrantTrainStationSceneBig"]),
            Stories(previewImage: "HarvestOfGenerationsPreview", images: ["HarvestOfGenerationsBig", "TheGreatPumpkinParadeBig"]),
            Stories(previewImage: "MelodiesOnTheMovePreview", images: ["MelodiesOnTheMoveBig", "MelodiesOnTheMoveContinueBig"]),
            Stories(previewImage: "QuietCompanionshipPreview", images: ["QuietCompanionshipBig", "QuietMomentsInTransitBig"])
        ]
    }
    
    // MARK: - Timer Control
    func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 0.05, on: .main, in: .common)
        cancellable = timer
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                withAnimation(.linear(duration: 0.05)) {
                    self.progress += 0.05 / self.imageDuration
                    if self.progress >= 1.0 {
                        self.switchToNextStory()
                    }
                }
            }
    }
    
    func stopTimer() {
        cancellable?.cancel()
        withAnimation(.linear) {
            progress = 0.0
        }
    }
    
    // MARK: - Story Navigation
    func switchToNextStory() {
        withAnimation(.linear) {
            progress = 0.0
        }
        if currentImageIndex < story[currentStoryIndex].images.count - 1 {
            currentImageIndex += 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else if currentStoryIndex < story.count - 1 {
            viewedStories.insert(story[currentStoryIndex].id)
            currentStoryIndex += 1
            currentImageIndex = 0
            viewedStories.insert(story[currentStoryIndex].id)
        } else {
            viewedStories.insert(story[currentStoryIndex].id)
            currentStoryIndex = 0
            currentImageIndex = 0
            stopTimer()
            showStoryView = false
        }
    }
    
    func switchToPreviousStory() {
        withAnimation(.linear) {
            progress = 0.0
        }
        if currentImageIndex > 0 {
            currentImageIndex -= 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            currentImageIndex = story[currentStoryIndex].images.count - 1
            viewedStories.insert(story[currentStoryIndex].id)
        } else {
            currentStoryIndex = 0
            currentImageIndex = 0
            stopTimer()
            showStoryView = false
        }
    }
    
    // MARK: - Selection & Viewed State
    func selectStory(at index: Int) {
        currentStoryIndex = index
        currentImageIndex = 0
        withAnimation(.linear) {
            progress = 0.0
        }
        viewedStories.insert(story[currentStoryIndex].id)
        showStoryView = true
    }
    
    func isStoryViewed(_ story: Stories) -> Bool {
        viewedStories.contains(story.id)
    }
}
