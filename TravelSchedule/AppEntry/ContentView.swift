//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 6/26/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - State
    @State private var selectedTabIndex = 0
    @State private var fromCity: City?
    @State private var fromStation: RailwayStation?
    @State private var toCity: City?
    @State private var toStation: RailwayStation?
    @State private var hasFinishedSplash = false
    @State private var navigationPath = NavigationPath()
    @StateObject private var carrierViewModel = CarrierRouteViewModel()
    
    @AppStorage(SettingsKeys.Appearance.isDarkMode) private var isDarkMode = false
    @AppStorage(SettingsKeys.Appearance.userHasSetDarkMode) private var userHasSetDarkMode = false
    
    private var effectiveColorScheme: ColorScheme? {
        userHasSetDarkMode ? isDarkMode ? .dark : .light : nil
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .top) {
                TabView(selection: $selectedTabIndex) {
                    RouteSelectionView(
                        fromCity: $fromCity,
                        fromStation: $fromStation,
                        toCity: $toCity,
                        toStation: $toStation,
                        navigationPath: $navigationPath,
                        carrierViewModel: carrierViewModel
                    )
                    .tabItem {
                        Label("", image: selectedTabIndex == 0 ? "ScheduleActive" : "ScheduleNotActive").accessibilityLabel("Поиск расписания")
                    }
                    .tag(0)
                    .accessibilityIdentifier("tab_schedule")
                    SettingsView()
                        .tabItem {
                            Label("", image: selectedTabIndex == 1 ? "SettingsActive" : "SettingsNotActive").accessibilityLabel("Настройки")
                        }
                        .tag(1)
                        .accessibilityIdentifier("tab_settings")
                }
                .accessibilityIdentifier("mainTabView")
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.3))
                        .accessibilityHidden(true)
                        .offset(y: -49),
                    alignment: .bottom
                )
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .cities(let isSelectingFrom):
                    CitySelectionView(
                        selectedCity: isSelectingFrom ? $fromCity : $toCity,
                        selectedStation: isSelectingFrom ? $fromStation : $toStation,
                        isSelectingFrom: isSelectingFrom,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .stations(let city, let isSelectingFrom):
                    StationSelectionView(
                        selectedCity: city,
                        selectedStation: isSelectingFrom ? $fromStation : $toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .carriers(let fromCity, let fromStation, let toCity, let toStation):
                    CarriersListView(
                        viewModel: carrierViewModel,
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .filters(let fromCity, let fromStation, let toCity, let toStation):
                    FiltersView(
                        viewModel: carrierViewModel,
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .preferredColorScheme(effectiveColorScheme)
        .overlay {
            SplashScreen()
                .opacity(hasFinishedSplash ? 0 : 1)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { hasFinishedSplash = true }
            }
        }
    }
}

#Preview {
    ContentView()
}
