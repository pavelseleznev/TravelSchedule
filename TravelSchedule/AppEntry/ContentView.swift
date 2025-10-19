//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 6/26/25.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - ViewModels
    @State private var routeSelectionViewModel = RouteSelectionViewModel()
    @State private var settingsViewModel = SettingsViewModel()
    @State private var carrierViewModel = CarrierListViewModel()
    @State private var filterViewModel = FilterViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $routeSelectionViewModel.navigationPath) {
            ZStack(alignment: .top) {
                TabView(selection: $routeSelectionViewModel.selectedTabIndex) {
                    RouteSelectionView()
                        .environment(routeSelectionViewModel)
                        .environment(carrierViewModel)
                        .tabItem {
                            Label("", image: routeSelectionViewModel.selectedTabIndex == 0 ? "ScheduleIconActive" : "ScheduleIconNotActive").accessibilityLabel("Поиск расписания")
                        }
                        .tag(0)
                        .accessibilityIdentifier("tab_schedule")
                    SettingsView(navigationPath: $routeSelectionViewModel.navigationPath)
                        .tabItem {
                            Label("", image: routeSelectionViewModel.selectedTabIndex == 1 ? "SettingsActive" : "SettingsNotActive").accessibilityLabel("Настройки")
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
                        selectedCity: isSelectingFrom ? $routeSelectionViewModel.fromCity : $routeSelectionViewModel.toCity,
                        selectedStation: isSelectingFrom ? $routeSelectionViewModel.fromStation : $routeSelectionViewModel.toStation,
                        isSelectingFrom: isSelectingFrom,
                        navigationPath: $routeSelectionViewModel.navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .stations(let city, let isSelectingFrom):
                    StationSelectionView(
                        selectedCity: city,
                        selectedStation: isSelectingFrom ? $routeSelectionViewModel.fromStation : $routeSelectionViewModel.toStation,
                        navigationPath: $routeSelectionViewModel.navigationPath
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .carriers(let fromCity, let fromStation, let toCity, let toStation):
                    CarriersListView(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $routeSelectionViewModel.navigationPath
                    )
                    .environment(carrierViewModel)
                    .toolbar(.hidden, for: .tabBar)
                case .filters(let fromCity, let fromStation, let toCity, let toStation):
                    FilterView(
                        fromCity: fromCity,
                        fromStation: fromStation,
                        toCity: toCity,
                        toStation: toStation,
                        navigationPath: $routeSelectionViewModel.navigationPath
                    )
                    .environment(carrierViewModel)
                    .environment(filterViewModel)
                    .toolbar(.hidden, for: .tabBar)
                case .carrierDetails(let route):
                    CarrierDetailsView(navigationPath: $routeSelectionViewModel.navigationPath
                    )
                    .environment(CarrierDetailsViewModel(route: route))
                    .toolbar(.hidden, for: .tabBar)
                }
            }
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                case .agreement(let isDarkMode):
                    AgreementView(isDarkMode: isDarkMode, navigationPath: $routeSelectionViewModel.navigationPath)
                        .toolbar(.hidden, for: .tabBar)
                case .noInternet:
                    Text("No internet")
                        .toolbar(.hidden, for: .tabBar)
                case .serverError:
                    Text("Server error")
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .environment(settingsViewModel)
        .preferredColorScheme(settingsViewModel.userHasSetDarkMode ? (settingsViewModel.isDarkMode ? .dark : .light) : nil)
        .overlay {
            SplashScreen()
                .opacity(routeSelectionViewModel.hasFinishedSplash ? 0 : 1)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { routeSelectionViewModel.hasFinishedSplash = true }
            }
        }
    }
}

#Preview {
    ContentView()
}
