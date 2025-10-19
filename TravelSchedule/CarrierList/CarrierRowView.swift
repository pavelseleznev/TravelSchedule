//
//  CarrierRowView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct CarrierRowView: View {
    
    // MARK: - Property
    var route: CarrierRoute
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                AsyncImageView(
                    url: route.carrierImageURL,
                    placeholder: "",
                    width: 38,
                    height: 38,
                    cornerRadius: 12,
                    fallbackSystemImageName: route.carrierImage
                )
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
    CarrierRowView(route: CarrierRoute(
        carrierName: "РЖД", date: "17 января",
        departureTime: "22:30",
        arrivalTime: "08:15",
        duration: "20 часов",
        withTransfer: true,
        carrierImage: "train.side.front.car",
        carrierImageURL: "https://yastat.net/s3/rasp/media/data/company/logo/112.png",
        note: "С пересадкой в Костроме",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71"
    ))
}
