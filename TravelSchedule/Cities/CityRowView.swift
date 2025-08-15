//
//  CityRowView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct CityRowView: View {
    
    // MARK: - Property
    var city: City
    
    // MARK: - Body
    var body: some View {
        HStack {
            Text(city.cityName)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground).opacity(0.2))
                .cornerRadius(8)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10.91, height: 18.82)
                    .foregroundStyle(.blackDayNight)
            }
            .accessibilityHint(Text("Выбрать город"))
            .accessibilityIdentifier("cityRowChevronButton_\(city.cityName)")
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(city.cityName)
            .accessibilityAddTraits(.isButton)
        }
        .padding(.trailing, 8)
    }
}

#Preview {
    CityRowView(city: City(cityName: "Санкт-Петербург"))
}
