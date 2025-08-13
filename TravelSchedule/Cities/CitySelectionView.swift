//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/30/25.
//

import SwiftUI

struct CitySelectionView: View {
    
    // MARK: - ViewModel & Bindings
    @Binding var selectedCity: City?
    @Binding var selectedStation: RailwayStation?
    let isSelectingFrom: Bool
    @Binding var navigationPath: NavigationPath
    @State private var searchCity = ""
    @StateObject private var viewModel = CityViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Computed Properties
    private var filteredCities: [City] {
        searchCity.isEmpty ? viewModel.cities : viewModel.cities.filter { $0.cityName.lowercased().contains(searchCity.lowercased()) }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        if selectedStation == nil { selectedCity = nil }
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
                Text("Выбор города")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("citySelectionTitle")
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
            
            SearchBar(text: $searchCity)
                .accessibilityLabel(Text("Поиск города"))
                .accessibilityHint(Text("Введите название города"))
                .accessibilityIdentifier("citySearchBar")
                .padding(.bottom, 16)
            
            ScrollView {
                if filteredCities.isEmpty {
                    VStack {
                        Spacer()
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blackDayNight)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 238)
                            .accessibilityIdentifier("noCityFoundMessage")
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 200)
                } else {
                    LazyVStack {
                        ForEach(filteredCities) { city in
                            Button(action: {
                                selectedCity = city
                                navigationPath.append(Destination.stations(
                                    city: city,
                                    isSelectingFrom: isSelectingFrom))
                            }) {
                                CityRowView(city: city)
                                    .foregroundStyle(.blackDayNight)
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(Text(city.cityName))
                                    .accessibilityHint(Text("Выбрать город"))
                                    .accessibilityIdentifier("cityRow_\(city.cityName)")
                            }
                        }
                    }
                }
            }
            .accessibilityIdentifier("cityListScrollView")
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CitySelectionView(
        selectedCity: .constant(nil),
        selectedStation: .constant(nil),
        isSelectingFrom: true,
        navigationPath: .constant(NavigationPath())
    )
}
