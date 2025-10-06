//
//  CarrierDetailsView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 9/3/25.
//

import SwiftUI

// MARK: - CarrierDetailsView
struct CarrierDetailsView: View {
    
    // MARK: - Properties
    let route: CarrierRoute
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack {
            headerView
            contentView
        }
    }
}

// MARK: - Subviews
private extension CarrierDetailsView {
    
    // MARK: Header
    var headerView: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }
            titleView
        }
        .padding(.horizontal, 8)
        .padding(.top, 11)
    }
    
    // MARK: Back Button
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 22)
                .foregroundStyle(.blackDayNight)
        }
        .accessibilityLabel(Text("Назад"))
        .accessibilityHint(Text("Вернуться назад"))
        .accessibilityIdentifier("backButton")
    }
    
    // MARK: Title
    var titleView: some View {
        Text("Информация о перевозчике")
            .font(.system(size: 17, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .center)
            .accessibilityAddTraits(.isHeader)
            .accessibilityIdentifier("carrierDetailsTitle")
    }
    
    // MARK: Content
    var contentView: some View {
        ZStack {
            VStack(spacing: 16) {
                carrierLogo
                carrierInfoBlock
                Spacer()
            }
            .padding()
            .accessibilityIdentifier("carrierDetails")
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: Logo
    var carrierLogo: some View {
        Image("RusRailwaysLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 343, height: 104)
            .padding(.top, 16)
    }
    
    // MARK: Info Block
    var carrierInfoBlock: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ОАО «\(route.carrierName)»")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.blackDayNight)
            
            VStack(alignment: .leading, spacing: 0) {
                infoRow(title: "E-mail", value: route.email ?? "—", color: .blueUniversal)
                infoRow(title: "Телефон", value: route.phone ?? "—", color: .blueUniversal)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
    
    // MARK: Info Row
    func infoRow(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.blackDayNight)
                .padding(.top, 12)
            Text(value)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(color)
                .padding(.bottom, 12)
        }
    }
}

#Preview {
    CarrierDetailsView(
        route: CarrierRoute(
            carrierName: "РЖД",
            date: "17 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            withTransfer: true,
            carrierImage: "RusRailwaysBrandIcon",
            note: "С пересадкой в Костроме",
            email: "info@rzd.ru",
            phone: "+7 800 775-00-00"
        ),
        navigationPath: .constant(NavigationPath())
    )
}
