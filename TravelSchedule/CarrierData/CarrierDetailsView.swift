//
//  CarrierDetailsView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 9/3/25.
//

import SwiftUI

struct CarrierDetailsView: View {
    
    // MARK: - Property, Binding & Environment
    let route: CarrierRoute
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack {
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
                    .accessibilityHint(Text("Вернуться назад"))
                    .accessibilityIdentifier("backButton")
                    Spacer()
                }
                Text("Информация о перевозчике")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("carrierDetailsTitle")
            }
            .padding(.horizontal, 8)
            .padding(.top, 11)
            
            ZStack() {
                VStack(spacing: 16) {
                    Image("RusRailwaysLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 343, height: 104)
                        .padding(.top, 16)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ОАО «" + (route.carrierName) + "»")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.blackDayNight)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("E-mail")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.blackDayNight)
                                .padding(.top, 12)
                            Text(route.email ?? "—")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.blueUniversal)
                                .padding(.bottom, 12)
                            Text("Телефон")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.blackDayNight)
                                .padding(.top, 12)
                            Text(route.phone ?? "—")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.blueUniversal)
                                .padding(.bottom, 12)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding()
                .accessibilityIdentifier("carrierDetails")
                .toolbar(.hidden, for: .tabBar)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    CarrierDetailsView(
        route: CarrierRoute(carrierName: "РЖД", date: "17 января", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", withTransfer: true, carrierImage: "RusRailwaysBrandIcon", note: "С пересадкой в Костроме", email: "info@rzd.ru", phone: "+7 800 775-00-00"),
        navigationPath: .constant(NavigationPath()))
}
