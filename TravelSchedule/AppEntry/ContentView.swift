//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 6/26/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - State
    @State private var selectedTab = 0
    @State private var fromCity: City?
    @State private var fromStation: RailwayStation?
    @State private var toCity: City?
    @State private var toStation: RailwayStation?
    @State private var hasFinishedSplash = false
    @State private var navigationPath = NavigationPath()
    @StateObject private var carrierViewModel = CarrierRouteViewModel()
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("userHasSetDarkMode") private var userHasSetDarkMode = false
    
    private var effectiveColorScheme: ColorScheme? {
        if userHasSetDarkMode {
            return isDarkMode ? .dark : .light
        } else {
            return nil
        }
    }
    
    // MARK: - Body
    var body: some View {
        if hasFinishedSplash {
            ZStack(alignment: .top) {
                TabView(selection: $selectedTab) {
                    RouteSelectionView(
                        fromCity: $fromCity,
                        fromStation: $fromStation,
                        toCity: $toCity,
                        toStation: $toStation,
                        navigationPath: $navigationPath,
                        carrierViewModel: carrierViewModel
                    )
                    .tabItem {
                        Label("", image: selectedTab == 0 ? "ScheduleActive" : "ScheduleNotActive").accessibilityLabel("Поиск расписания")
                    }
                    .tag(0)
                    .accessibilityIdentifier("tab_schedule")
                    SettingsView()
                        .tabItem {
                            Label("", image: selectedTab == 1 ? "SettingsActive" : "SettingsNotActive").accessibilityLabel("Настройки")
                        }
                        .tag(1)
                        .accessibilityIdentifier("tab_settings")
                }
                .accessibilityIdentifier("mainTabView")
                .overlay(alignment: .bottom) {
                    if (selectedTab == 0 || selectedTab == 1) && navigationPath.isEmpty {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray.opacity(0.3))
                            .accessibilityHidden(true)
                            .offset(y: -49)
                    }
                }
            }
            .preferredColorScheme(effectiveColorScheme)
        } else {
            SplashScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            hasFinishedSplash = true
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
