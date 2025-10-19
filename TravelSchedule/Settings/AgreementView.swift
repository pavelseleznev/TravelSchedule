//
//  AgreementView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 9/18/25.
//

import SwiftUI

struct AgreementView: View {
    
    // MARK: - Properties
    var isDarkMode: Bool
    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer")
    @State private var viewModel = AgreementViewModel()
    
    // MARK: - Binding & Environment
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
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
            Text("Пользовательское соглашение")
                .font(.system(size: 17, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("agreementDetailsTitle")
        }
        .padding(.horizontal, 8)
        .padding(.top, 11)
        .task {
            await viewModel.loadData()
        }
        
        Group {
            if viewModel.isConnected {
                if let url = agreementURL {
                    AgreementWebView(url: url)
                        .edgesIgnoringSafeArea(.bottom)
                        .navigationBarBackButtonHidden(true)
                }
            } else {
                ErrorView(errorType: .noInternet)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    AgreementView(isDarkMode: true, navigationPath: .constant(NavigationPath()))
}
