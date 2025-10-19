//
//  RouteSelectionView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/29/25.
//

import SwiftUI

struct RouteSelectionView: View {
    
    // MARK: - ViewModels
    @Environment(RouteSelectionViewModel.self) private var routeSelectionViewModel
    @Environment(CarrierListViewModel.self) private var carrierViewModel
    @State private var storiesViewModel = StoriesViewModel()
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 44) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    ForEach(storiesViewModel.story) { story in
                        StoriesCell(stories: story)
                            .environment(storiesViewModel)
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
                                routeSelectionViewModel.navigationPath.append(Destination.cities(isSelectingFrom: true))
                            }) {
                                Text(routeSelectionViewModel.fromText)
                                    .foregroundStyle(routeSelectionViewModel.fromCity == nil ? .grayUniversal : .blackUniversal)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityLabel("Откуда")
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityHint(Text("Выбрать город и станцию отправления"))
                            .accessibilityIdentifier("fromCityButton")
                            
                            Button(action: {
                                routeSelectionViewModel.navigationPath.append(Destination.cities(isSelectingFrom: false))
                            }) {
                                Text(routeSelectionViewModel.toText)
                                    .foregroundStyle(routeSelectionViewModel.toCity == nil ? .grayUniversal : .blackUniversal)
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
                            routeSelectionViewModel.swapCities()
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
                if routeSelectionViewModel.isFindButtonEnabled {
                    Button(action: {
                        if let fromCity = routeSelectionViewModel.fromCity,
                           let fromStation = routeSelectionViewModel.fromStation,
                           let toCity = routeSelectionViewModel.toCity,
                           let toStation = routeSelectionViewModel.toStation {
                            routeSelectionViewModel.navigationPath.append(Destination.carriers(
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
        .fullScreenCover(isPresented: $storiesViewModel.showStoryView) {
            StoryView(viewModel: storiesViewModel)
        }
        .accessibilityIdentifier("routeSelectionContent")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    RouteSelectionView()
        .environment(RouteSelectionViewModel())
        .environment(CarrierListViewModel())
}
