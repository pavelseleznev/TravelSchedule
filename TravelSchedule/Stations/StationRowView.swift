//
//  StationRowView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct RailwayStationRowView: View {
    
    // MARK: - Property
    var railwayStation: RailwayStation
    
    // MARK: - Body
    var body: some View {
        HStack {
            Text(railwayStation.name)
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
            .accessibilityHint(Text("Выбрать станцию"))
            .accessibilityIdentifier("stationRowChevronButton_\(railwayStation.name)")
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(railwayStation.name)
            .accessibilityAddTraits(.isButton)
        }
        .padding(.trailing, 8)
    }
}

#Preview {
    RailwayStationRowView(railwayStation: RailwayStation(name: "Киевский вокзал"))
}
