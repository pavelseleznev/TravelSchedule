//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/2/25.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Environment, StateObject & AppStorage
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showNoInternet = false
    @State private var showServerError = false
    @StateObject private var navigationController = NavigationController()
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("useSystemAppearance") private var useSystemAppearance = true
    @AppStorage("userHasSetDarkMode") private var userHasSetDarkMode = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationController.path) {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Use System Appearance", isOn: $useSystemAppearance)
                        .padding(.horizontal, 16)
                        .onChange(of: useSystemAppearance) { _, newValue in
                            userHasSetDarkMode = !newValue
                        }
                        .accessibilityHint(Text("Включите, чтобы использовать светлую или тёмную тему системы"))
                        .accessibilityIdentifier("toggleUseSystemAppearance")
                    
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .padding(.horizontal, 16)
                        .disabled(useSystemAppearance)
                        .onChange(of: isDarkMode) {
                            if !useSystemAppearance {
                                userHasSetDarkMode = true
                            }
                        }
                    
                        .onChange(of: colorScheme, initial: true) { _, newScheme in
                            if useSystemAppearance {
                                isDarkMode = (newScheme == .dark)
                            }
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
            .toolbar(.visible, for: .tabBar)
        }
        .fullScreenCover(isPresented: $showNoInternet) {
            NavigationStack {
                ErrorView(errorType: .noInternet)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showNoInternet = false
                            }) {
                                Label("Назад", systemImage: "chevron.left")
                                    .labelStyle(.titleAndIcon)
                                    .foregroundStyle(.blackDayNight)
                            }
                            .accessibilityHint(Text("Закрыть экран ошибки и вернуться к настройкам"))
                            .accessibilityIdentifier("backFromNoInternet")
                        }
                    }
            }
        }
        .fullScreenCover(isPresented: $showServerError) {
            NavigationStack {
                ErrorView(errorType: .serverError)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showServerError = false
                            }) {
                                Label("Назад", systemImage: "chevron.left")
                                    .labelStyle(.titleAndIcon)
                                    .foregroundStyle(.blackDayNight)
                            }
                            .accessibilityHint(Text("Закрыть экран ошибки и вернуться к настройкам"))
                            .accessibilityIdentifier("backFromServerError")
                        }
                    }
            }
        }
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light)
}
