//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct StationSelectionView: View {
    
    // MARK: - ViewModel & Bindings
    let selectedCity: City
    @Binding var selectedStation: RailwayStation?
    @Binding var navigationPath: NavigationPath
    @State private var searchStation = ""
    @StateObject var viewModel = RailwayStationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Computed Property
    private var filteredRailwayStations: [RailwayStation] {
        searchStation.isEmpty ? viewModel.railwayStations : viewModel.railwayStations.filter {
            $0.name.lowercased().contains(searchStation.lowercased())
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 22)
                            .foregroundStyle(.blackDayNight)
                    }
                    .accessibilityLabel(Text("Назад"))
                    .accessibilityHint(Text("Вернуться назад"))
                    .accessibilityIdentifier("backButton")
                    Spacer()
                }
                Text("Выбор станции")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("stationSelectionTitle")
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
            
            SearchBar(text: $searchStation)
                .accessibilityLabel(Text("Поиск станции"))
                .accessibilityHint(Text("Введите название станции"))
                .accessibilityIdentifier("stationSearchBar")
                .padding(.bottom, 16)
            
            ScrollView() {
                if filteredRailwayStations.isEmpty {
                    VStack {
                        Spacer()
                        Text("Станция не найдена")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blackDayNight)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 238)
                            .accessibilityIdentifier("noStationFoundMessage")
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 200)
                } else {
                    LazyVStack{
                        ForEach(filteredRailwayStations) { station in
                            Button(action: {
                                selectedStation = station
                                navigationPath.removeLast(navigationPath.count)
                            }) {
                                RailwayStationRowView(railwayStation: station)
                                    .foregroundStyle(.blackDayNight)
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(Text(station.name))
                                    .accessibilityHint(Text("Выбрать станцию"))
                                    .accessibilityIdentifier("stationRow_\(station.name)")
                            }
                        }
                    }
                }
            }
            .accessibilityIdentifier("stationListScrollView")
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    StationSelectionView(
        selectedCity: City(cityName: "Москва"),
        selectedStation: .constant(nil),
        navigationPath: .constant(NavigationPath())
    )
}
