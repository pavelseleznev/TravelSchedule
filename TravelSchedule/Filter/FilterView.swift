//
//  FilterView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct FiltersView: View {
    
    // MARK: - Environment, ViewModel, Properties & Binding
    @ObservedObject var viewModel: CarrierRouteViewModel
    let fromCity: City
    let fromStation: RailwayStation
    let toCity: City
    let toStation: RailwayStation
    @Binding var navigationPath: NavigationPath
    @State private var showWithTransfer: Bool?
    @State private var tempSelectedPeriods: Set<TimePeriod> = []
    @State private var tempShowWithTransfer: Bool?
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                    .accessibilityHint(Text("Вернуться к списку результатов"))
                    Spacer()
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
        }
        VStack(alignment: .leading, spacing: 16) {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDayNight)
                .accessibilityAddTraits(.isHeader)
            
            ForEach(TimePeriod.allCases, id: \.self) { period in
                HStack {
                    Text(period.rawValue)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDayNight)
                    Spacer()
                    Button(action: {
                        if tempSelectedPeriods.contains(period) {
                            tempSelectedPeriods.remove(period)
                        } else {
                            tempSelectedPeriods.insert(period)
                        }
                    }) { Image(systemName: tempSelectedPeriods.contains(period) ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.blackDayNight))
                            .accessibilityHidden(true)
                    }
                }
                .frame(height: 60)
                .padding(.trailing, 2)
                .contentShape(Rectangle())
                .onTapGesture {
                    if tempSelectedPeriods.contains(period) {
                        tempSelectedPeriods.remove(period)
                    } else {
                        tempSelectedPeriods.insert(period)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(period.rawValue))
                .accessibilityValue(Text(tempSelectedPeriods.contains(period) ? "выбрано" : "не выбрано"))
                .accessibilityHint(Text(tempSelectedPeriods.contains(period) ? "Дважды коснитесь, чтобы убрать фильтр" : "Дважды коснитесь, чтобы выбрать фильтр"))
                .accessibilityAddTraits(tempSelectedPeriods.contains(period) ? .isSelected : [])
                .accessibilityAction {
                    if tempSelectedPeriods.contains(period) {
                        tempSelectedPeriods.remove(period)
                    } else {
                        tempSelectedPeriods.insert(period)
                    }
                }
            }
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 16)
                .accessibilityAddTraits(.isHeader)
            HStack {
                Text("Да")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackDayNight)
                Spacer()
                Button(action: { tempShowWithTransfer = true }) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 20, height: 20)
                        if tempShowWithTransfer == true {
                            Circle()
                                .frame(width: 10, height: 10)
                        }
                    }
                    .foregroundStyle(.blackDayNight)
                    .accessibilityHidden(true)
                }
            }
            .frame(height: 60)
            .padding(.trailing, 2)
            .contentShape(Rectangle())
            .onTapGesture { tempShowWithTransfer = true }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Показывать варианты с пересадками: Да"))
            .accessibilityValue(Text(tempShowWithTransfer == true ? "выбрано" : "не выбрано"))
            .accessibilityHint(Text("Дважды коснитесь, чтобы выбрать вариант 'Да'"))
            .accessibilityAddTraits(tempShowWithTransfer == true ? .isSelected : [])
            .accessibilityAction { tempShowWithTransfer = true }
            HStack {
                Text("Нет")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackDayNight)
                Spacer()
                Button(action: {
                    tempShowWithTransfer = false
                }) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 20, height: 20)
                        if tempShowWithTransfer == false {
                            Circle()
                                .frame(width: 10, height: 10)
                        }
                    }
                    .foregroundStyle(.blackDayNight)
                    .accessibilityHidden(true)
                }
                .frame(height: 60)
                .padding(.trailing, 2)
            }
            .frame(height: 60)
            .padding(.trailing, 2)
            .contentShape(Rectangle())
            .onTapGesture { tempShowWithTransfer = false }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Показывать варианты с пересадками: Нет"))
            .accessibilityValue(Text(tempShowWithTransfer == false ? "выбрано" : "не выбрано"))
            .accessibilityHint(Text("Дважды коснитесь, чтобы выбрать вариант 'Нет'"))
            .accessibilityAddTraits(tempShowWithTransfer == false ? .isSelected : [])
            .accessibilityAction { tempShowWithTransfer = false }
            Spacer()
            if !tempSelectedPeriods.isEmpty || tempShowWithTransfer != nil {
                Button(action: {
                    viewModel.selectedPeriods = tempSelectedPeriods
                    viewModel.showWithTransfer = tempShowWithTransfer
                    navigationPath.removeLast()
                }) {
                    Text("Применить")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(.white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                }
                .background(Color(.blueUniversal))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 24)
                .accessibilityLabel(Text("Применить фильтры"))
                .accessibilityHint(Text("Применить выбранные параметры фильтрации"))
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FiltersView(
        viewModel: CarrierRouteViewModel(),
        fromCity: City(cityName: "Москва"),
        fromStation: RailwayStation(name: "Киевский вокзал"),
        toCity: City(cityName: "Санкт-Петербург"),
        toStation: RailwayStation(name: "Московский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
}
