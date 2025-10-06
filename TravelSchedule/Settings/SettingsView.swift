//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/2/25.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Binding
    @Binding var navigationPath: NavigationPath
    
    // MARK: - AppStorage
    @AppStorage(SettingsKeys.Appearance.isDarkMode) private var isDarkMode = false
    @AppStorage(SettingsKeys.Appearance.userHasSetDarkMode) private var userHasSetDarkMode = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Тёмная тема", isOn: $isDarkMode)
                .padding(.horizontal, 16)
                .onChange(of: isDarkMode) {
                    userHasSetDarkMode = true
                }
                .tint(Color.blueUniversal)
                .accessibilityHint(Text("Переключает тёмную тему приложения"))
                .accessibilityIdentifier("toggleDarkMode")
            
            Button(action: {
                navigationPath.append(SettingsDestination.agreement(isDarkMode: isDarkMode))
            }) {
                HStack {
                    Text("Пользовательское соглашение")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground).opacity(0.2))
                        .cornerRadius(8)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10.91, height: 18.82)
                        .foregroundStyle(.blackDayNight)
                        .frame(width: 44, height: 44)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            .accessibilityHint(Text("Открыть пользовательское соглашение"))
            .accessibilityLabel("Пользовательское соглашение")
            .accessibilityAddTraits(.isButton)
            .padding(.trailing, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(.system(size: 12, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Версия 1.0 (beta)")
                    .font(.system(size: 12, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 18)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 24)
        }
        .navigationTitle("Settings")
        .toolbar(.visible, for: .tabBar)
    }
}

#Preview {
    SettingsView(navigationPath: .constant(NavigationPath()))
}
