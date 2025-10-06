//
//  CarriersRowView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct CarriersRowView: View {
    
    // MARK: - Property
    var route: CarrierRoute
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(route.carrierImage)
                    .resizable()
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 2) {
                    Text(route.carrierName)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.blackUniversal)
                    if let note = route.note {
                        Text(note)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.redUniversal)
                    }
                }
                Spacer()
                Text(route.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.blackUniversal)
            }
            .padding(.bottom, 5)
            
            HStack {
                Text(route.departureTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackUniversal)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.grayUniversal)
                Text(route.duration)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.blackUniversal)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.grayUniversal)
                Text(route.arrivalTime)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(.blackUniversal)
            }
        }
        .padding()
        .background(.lightGrayUniversal)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    CarriersRowView(route: CarrierRoute(
        carrierName: "РЖД", date: "17 января",
        departureTime: "22:30",
        arrivalTime: "08:15",
        duration: "20 часов",
        withTransfer: true,
        carrierImage: "RusRailwaysBrandIcon",
        note: "С пересадкой в Костроме",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71"
    ))
}
