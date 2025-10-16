//
//  FilterView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct FilterView: View {
    
    // MARK: - Inputs
    let fromCity: City
    let fromStation: RailwayStation
    let toCity: City
    let toStation: RailwayStation
    @Binding var navigationPath: NavigationPath
    
    // MARK: - Environment
    @Environment(CarrierListViewModel.self) private var routes
    @Environment(FilterViewModel.self) private var filterModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        @Bindable var model = filterModel
        
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
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
                    Text(period.localized)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackDayNight)
                    Spacer()
                    Button(action: { model.toggle(period) }) {
                        Image(systemName: model.tempSelectedPeriods.contains(period)
                              ? "checkmark.square.fill"
                              : "square")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(.blackDayNight))
                        .accessibilityHidden(true)
                    }
                }
                .frame(height: 60)
                .padding(.trailing, 2)
                .contentShape(Rectangle())
                .onTapGesture { model.toggle(period) }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(period.localized))
                .accessibilityValue(Text(model.tempSelectedPeriods.contains(period)
                                         ? "выбрано"
                                         : "не выбрано"))
                .accessibilityHint(Text(model.tempSelectedPeriods.contains(period)
                                        ? "Дважды коснитесь, чтобы убрать фильтр"
                                        : "Дважды коснитесь, чтобы выбрать фильтр"))
                .accessibilityAddTraits(model.tempSelectedPeriods.contains(period)
                                        ? .isSelected
                                        : [])
                .accessibilityAction { model.toggle(period) }
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
                Button(action: { model.setShowWithTransfer(true) }) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 20, height: 20)
                        if model.tempShowWithTransfer == true {
                            Circle().frame(width: 10, height: 10)
                        }
                    }
                    .foregroundStyle(.blackDayNight)
                    .accessibilityHidden(true)
                }
            }
            .frame(height: 60)
            .padding(.trailing, 2)
            .contentShape(Rectangle())
            .onTapGesture { model.setShowWithTransfer(true) }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Показывать варианты с пересадками: Да"))
            .accessibilityValue(Text(model.tempShowWithTransfer == true
                                     ? "выбрано"
                                     : "не выбрано"))
            .accessibilityHint(Text("Дважды коснитесь, чтобы выбрать вариант 'Да'"))
            .accessibilityAddTraits(model.tempShowWithTransfer == true
                                    ? .isSelected
                                    : [])
            .accessibilityAction { model.setShowWithTransfer(true) }
            
            HStack {
                Text("Нет")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackDayNight)
                Spacer()
                Button(action: { model.setShowWithTransfer(false) }) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 20, height: 20)
                        if model.tempShowWithTransfer == false {
                            Circle().frame(width: 10, height: 10)
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
            .onTapGesture { model.setShowWithTransfer(false) }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("Показывать варианты с пересадками: Нет"))
            .accessibilityValue(Text(model.tempShowWithTransfer == false
                                     ? "выбрано"
                                     : "не выбрано"))
            .accessibilityHint(Text("Дважды коснитесь, чтобы выбрать вариант 'Нет'"))
            .accessibilityAddTraits(model.tempShowWithTransfer == false
                                    ? .isSelected
                                    : [])
            .accessibilityAction { model.setShowWithTransfer(false) }
            
            Spacer()
            
            if model.shouldShowApplyButton {
                Button(action: {
                    model.apply(using: routes)
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
    FilterView(
        fromCity: City(cityName: "Москва"),
        fromStation: RailwayStation(name: "Киевский вокзал"),
        toCity: City(cityName: "Санкт-Петербург"),
        toStation: RailwayStation(name: "Московский вокзал"),
        navigationPath: .constant(NavigationPath())
    )
    .environment(CarrierListViewModel())
    .environment(FilterViewModel())
}
