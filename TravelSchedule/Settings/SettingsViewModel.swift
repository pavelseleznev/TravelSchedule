//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/9/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    
    // MARK: - Public Properties
    var isDarkMode: Bool {
        didSet {
            defaults.set(isDarkMode, forKey: SettingsKeys.Appearance.isDarkMode)
            userHasSetDarkMode = true
        }
    }
    
    var userHasSetDarkMode: Bool {
        didSet {
            defaults.set(userHasSetDarkMode, forKey: SettingsKeys.Appearance.userHasSetDarkMode)
        }
    }
    
    // MARK: - Private Property
    private let defaults: UserDefaults
    
    // MARK: - Public Method
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.isDarkMode = defaults.object(forKey: SettingsKeys.Appearance.isDarkMode) as? Bool ?? false
        self.userHasSetDarkMode = defaults.object(forKey: SettingsKeys.Appearance.userHasSetDarkMode) as? Bool ?? false
    }
}
