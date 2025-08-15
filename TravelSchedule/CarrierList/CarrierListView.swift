//
//  CarrierListView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct CarriersListView: View {
    
    // MARK: - Environment, ViewModel, Properties & Binding
    @ObservedObject var viewModel: CarrierRouteViewModel
    let fromCity: City
    let fromStation: RailwayStation
    let toCity: City
    let toStation: RailwayStation
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                HStack {
                    Button(action: {
                        viewModel.selectedPeriods.removeAll()
                        viewModel.showWithTransfer = nil
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
                        if !viewModel.filteredRoutes.isEmpty {
                            VStack(spacing: 0) {
                                ForEach(viewModel.filteredRoutes) { route in
                                    CarriersRowView(route: route)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
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
                            if !viewModel.selectedPeriods.isEmpty || viewModel.showWithTransfer != nil {
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
                    .accessibilityValue((!viewModel.selectedPeriods.isEmpty || viewModel.showWithTransfer != nil) ? Text("Фильтры применены") : Text("Фильтры не применены"))
                    .accessibilityHint(Text("Откроется экран фильтров"))
                    .navigationBarBackButtonHidden(true)
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    CarriersListView(
        viewModel: CarrierRouteViewModel(),
        fromCity: City(cityName: "Москва"),
        fromStation: RailwayStation(name: "Ярославский вокзал"),
        toCity: City(cityName: "Санкт-Петербург"),
        toStation: RailwayStation(name: "Балтийский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
}
