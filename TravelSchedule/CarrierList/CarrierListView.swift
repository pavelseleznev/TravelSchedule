//
//  CarrierListView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//


import SwiftUI

struct CarriersListView: View {
    
    // MARK: - Inputs
    let fromCity: City
    let fromStation: RailwayStation
    let toCity: City
    let toStation: RailwayStation
    @Binding var navigationPath: NavigationPath
    
    // MARK: - Environment / ViewModels
    @Environment(CarrierListViewModel.self) private var routeViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                HStack {
                    Button(action: {
                        routeViewModel.selectedPeriods.removeAll()
                        routeViewModel.showWithTransfer = nil
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 22)
                            .foregroundStyle(.blackDayNight)
                            .accessibilityHidden(true)
                    }
                    .accessibilityLabel(Text("Назад"))
                    Spacer()
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        Text("\(fromCity.cityName) (\(fromStation.name)) → \(toCity.cityName) (\(toStation.name))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blackDayNight)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.horizontal)
                        if routeViewModel.isLoading {
                            ProgressView("Загрузка расписания...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                        } else if let errorMessage = routeViewModel.errorMessage {
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
                        } else if !routeViewModel.filteredRoutes.isEmpty {
                            VStack(spacing: 0) {
                                ForEach(routeViewModel.filteredRoutes) { route in
                                    Button(action: {
                                        navigationPath.append(Destination.carrierDetails(route: route))
                                    }) {
                                        CarrierRowView(route: route)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                    }
                                }
                            }
                        } else {
                            VStack {
                                Spacer()
                                Text("Вариантов нет")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.blackDayNight)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 231)
                                    .accessibilityHint(Text("Попробуйте изменить фильтры"))
                                Spacer()
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
                .overlay(alignment: .bottom) {
                    Button(action: {
                        navigationPath.append(Destination.filters(
                            fromCity: fromCity,
                            fromStation: fromStation,
                            toCity: toCity,
                            toStation: toStation
                        ))
                    }) {
                        HStack(spacing: 4) {
                            Text("Уточнить время")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(Color(.white))
                            if !routeViewModel.selectedPeriods.isEmpty || routeViewModel.showWithTransfer != nil {
                                Circle()
                                    .fill(.redUniversal)
                                    .frame(width: 8, height: 8)
                                    .accessibilityHidden(true)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        
                        .background(Color(.blueUniversal))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 24)
                        .padding(.horizontal, 16)
                    }
                    .accessibilityLabel(Text("Уточнить время"))
                    .accessibilityValue((!routeViewModel.selectedPeriods.isEmpty || routeViewModel.showWithTransfer != nil) ? Text("Фильтры применены") : Text("Фильтры не применены"))
                    .accessibilityHint(Text("Откроется экран фильтров"))
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .task {
            let fromCode = fromStation.stationCode ?? ""
            let toCode = toStation.stationCode ?? ""
            guard !fromCode.isEmpty && !toCode.isEmpty else { return }
            await routeViewModel.loadSchedule(fromStation: fromCode, toStation: toCode)
        }
    }
}

#Preview {
    CarriersListView(
        fromCity: City(cityName: "Москва"),
        fromStation: RailwayStation(name: "Ярославский вокзал"),
        toCity: City(cityName: "Санкт-Петербург"),
        toStation: RailwayStation(name: "Балтийский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
    .environment(CarrierListViewModel())
}
