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
    @State private var viewModel = CityViewModel()
    @Environment(\.dismiss) private var dismiss
    
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
                .onChange(of: searchCity) { _, newValue in
                    viewModel.lookUpCity(query: newValue)
                }
            if viewModel.isLoading {
                ProgressView("Загрузка городов...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text("Ошибка")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    if viewModel.filteredCities.isEmpty {
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
                            ForEach(viewModel.filteredCities) { city in
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
            }
        }
        .task {
            await viewModel.loadAllCities()
        }
        .accessibilityIdentifier("cityListScrollView")
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
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
