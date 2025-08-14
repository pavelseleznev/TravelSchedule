//
//  RouteSelectionView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/29/25.
//

import SwiftUI

struct RouteSelectionView: View {
    
    // MARK: - ViewModel & Bindings
    @Binding var fromCity: City?
    @Binding var fromStation: RailwayStation?
    @Binding var toCity: City?
    @Binding var toStation: RailwayStation?
    @Binding var navigationPath: NavigationPath
    @State private var viewModel = StoriesViewModel()
    @ObservedObject var carrierViewModel: CarrierRouteViewModel
    
    // MARK: - Computed Properties
    private var isFindButtonEnabled: Bool {
        fromStation != nil && toStation != nil
    }
    
    private var fromText: String {
        if let city = fromCity, let station = fromStation {
            return "\(city.cityName) (\(station.name))"
        } else if let city = fromCity {
            return city.cityName
        }
        return "Откуда"
    }
    
    private var toText: String {
        if let city = toCity, let station = toStation {
            return "\(city.cityName) (\(station.name))"
        } else if let city = toCity {
            return city.cityName
        }
        return "Куда"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 44) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(viewModel.stories) { story in
                        StoriesCell(stories: story)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 144)
            .scrollIndicators(.hidden)
            .accessibilityLabel(Text("Истории"))
            .accessibilityHint(Text("Проведите по горизонтали, чтобы просмотреть"))
            .accessibilityIdentifier("storiesScroll")
            
            VStack(spacing: 16) {
                ZStack {
                    Color(UIColor(resource: .blueUniversal))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Button(action: {
                                navigationPath.append(Destination.cities(isSelectingFrom: true))
                            }) {
                                Text(fromText)
                                    .foregroundStyle(fromCity == nil ? .grayUniversal : .blackUniversal)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityLabel("Откуда")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityHint(Text("Выбрать город и станцию отправления"))
                            .accessibilityIdentifier("fromCityButton")
                            
                            Button(action: {
                                navigationPath.append(Destination.cities(isSelectingFrom: false))
                            }) {
                                Text(toText)
                                    .foregroundStyle(toCity == nil ? .grayUniversal : .blackUniversal)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityLabel("Куда")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityHint(Text("Выбрать город и станцию назначения"))
                            .accessibilityIdentifier("toCityButton")
                        }
                        .background(RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                        )
                        .padding(.horizontal, 16)
                        Button(action: {
                            let tempCity = fromCity
                            let tempStation = fromStation
                            fromCity = toCity
                            fromStation = toStation
                            toCity = tempCity
                            toStation = tempStation
                        }) {
                            Image("ChangeButton")
                                .frame(width: 36, height: 36)
                                .foregroundStyle(.blue)
                                .background(.white)
                                .clipShape(Circle())
                                .accessibilityLabel(Text("Поменять станции отправления и назначения местами"))
                        }
                        .padding(.trailing, 16)
                        .accessibilityHint(Text("Заменить местами выбранные пункты"))
                        .accessibilityIdentifier("swapStationsButton")
                    }
                    .padding(.vertical, 16)
                }
                
                .frame(height: 128)
                .padding(.horizontal, 16)
                if isFindButtonEnabled {
                    Button(action: {
                        if let fromCity = fromCity,
                           let fromStation = fromStation,
                           let toCity = toCity,
                           let toStation = toStation {
                            navigationPath.append(Destination.carriers(
                                fromCity: fromCity,
                                fromStation: fromStation,
                                toCity: toCity,
                                toStation: toStation))
                        }
                    }) {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 150, height: 40)
                            .padding(.vertical, 12)
                            .background(Color(UIColor(resource: .blueUniversal)))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .accessibilityLabel("Найти")
                    }
                    .padding(.horizontal, 16)
                    .accessibilityHint(Text("Показать доступных перевозчиков"))
                    .accessibilityIdentifier("findRoutesButton")
                }
            }
            Spacer()
            Divider()
                .frame(height: 3)
                .accessibilityHidden(true)
        }
        .padding(.top, 24)
        .accessibilityIdentifier("routeSelectionContent")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    RouteSelectionView(
        fromCity: .constant(nil),
        fromStation: .constant(nil),
        toCity: .constant(nil),
        toStation: .constant(nil),
        navigationPath: .constant(NavigationPath()),
        carrierViewModel: CarrierRouteViewModel())
}
