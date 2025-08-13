//
//  SplashScreen.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 7/29/25.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        Image("Splash")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .accessibilityIdentifier("splashScreenImage")
            .accessibilityHidden(true)
    }
}

#Preview {
    SplashScreen()
}
