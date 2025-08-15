//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/2/25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Environment & AppStorage
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showNoInternet = false
    @State private var showServerError = false
    
    @AppStorage(SettingsKeys.Appearance.isDarkMode) private var isDarkMode = false
    @AppStorage(SettingsKeys.Appearance.useSystemAppearance) private var useSystemAppearance = true
    @AppStorage(SettingsKeys.Appearance.userHasSetDarkMode) private var userHasSetDarkMode = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Use System Appearance", isOn: $useSystemAppearance)
                    .padding(.horizontal, 16)
                    .onChange(of: useSystemAppearance) { _, newValue in
                        userHasSetDarkMode = !newValue
                        if newValue {
                            // Keep isDarkMode in sync with current system scheme
                            isDarkMode = (colorScheme == .dark)
                        }
                    }
                    .accessibilityHint(Text("Включите, чтобы использовать светлую или тёмную тему системы"))
                    .accessibilityIdentifier("toggleUseSystemAppearance")
                
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding(.horizontal, 16)
                    .disabled(useSystemAppearance)
                    .onChange(of: isDarkMode) {
                        if !useSystemAppearance { userHasSetDarkMode = true }
                    }
                    .onChange(of: colorScheme, initial: true) { _, newScheme in
                        if useSystemAppearance { isDarkMode = (newScheme == .dark) }
                    }
                    .accessibilityHint(Text("Переключает тёмную тему приложения"))
                    .accessibilityIdentifier("toggleDarkMode")
            }
            
            SettingsButton(title: "Show 'No Internet connection' view") {
                showNoInternet = true
            }
            
            SettingsButton(title: "Show 'Server Error' view") {
                showServerError = true
            }
            
            Spacer()
        }
        .navigationTitle("Settings")
        .toolbar(.visible, for: .tabBar)
        .fullScreenCover(isPresented: $showNoInternet) {
            ZStack {
                ErrorView(errorType: .noInternet)
                    .overlay(alignment: .topLeading) {
                        Button {
                            showNoInternet = false
                        } label: {
                            Label("", systemImage: "chevron.left")
                                .labelStyle(.titleAndIcon)
                                .foregroundStyle(.blackDayNight)
                        }
                        .padding()
                        .position(x: -50, y: 1)
                        .accessibilityHint(Text("Закрыть экран ошибки и вернуться к настройкам"))
                        .accessibilityIdentifier("backFromNoInternet")
                    }
            }
        }
        .fullScreenCover(isPresented: $showServerError) {
            ZStack {
                ErrorView(errorType: .serverError)
                    .overlay(alignment: .topLeading) {
                        Button {
                            showServerError = false
                        } label: {
                            Label("", systemImage: "chevron.left")
                                .labelStyle(.titleAndIcon)
                                .foregroundStyle(.blackDayNight)
                        }
                        .padding()
                        .position(x: -50, y: 1)
                        .accessibilityHint(Text("Закрыть экран ошибки и вернуться к настройкам"))
                        .accessibilityIdentifier("backFromServerError")
                    }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light)
}
