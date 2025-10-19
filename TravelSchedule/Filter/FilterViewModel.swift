//
//  FilterViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/15/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class FilterViewModel {
    
    // MARK: - Temporary UI state
    var tempSelectedPeriods: Set<TimePeriod> = []
    var tempShowWithTransfer: Bool? = nil
    
    // MARK: - Derived state
    var shouldShowApplyButton: Bool {
        !tempSelectedPeriods.isEmpty || tempShowWithTransfer != nil
    }
    
    // MARK: - Public Methods
    func apply(using routes: CarrierListViewModel) {
        routes.selectedPeriods = tempSelectedPeriods
        routes.showWithTransfer = tempShowWithTransfer
    }
    
    func setShowWithTransfer(_ value: Bool) {
        tempShowWithTransfer = value
    }
    
    
    func toggle(_ period: TimePeriod) {
        set(period, !contains(period))
    }
    
    // MARK: - Private Methods
    private func set(_ period: TimePeriod, _ on: Bool) {
        if on { tempSelectedPeriods.insert(period) } else { tempSelectedPeriods.remove(period) }
    }
    
    private func contains(_ period: TimePeriod) -> Bool {
        tempSelectedPeriods.contains(period)
    }
}
