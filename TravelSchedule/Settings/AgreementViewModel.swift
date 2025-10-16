//
//  AgreementViewModel.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/16/25.
//

import Foundation
import Combine

@MainActor
@Observable
final class AgreementViewModel {
    
    // MARK: - Public Properties
    var showingError: Bool = false
    var isConnected: Bool = NetworkMonitor.shared.isConnected
    
    // MARK: - Private Property
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public Methods
    init() {
        NetworkMonitor.shared.$isConnected
            .sink { [weak self] value in
                Task { @MainActor in
                    self?.isConnected = value
                }
            }
            .store(in: &cancellables)
    }
    
    func loadData() async {
        if !isConnected {
            showingError = true
            return
        }
    }
}
