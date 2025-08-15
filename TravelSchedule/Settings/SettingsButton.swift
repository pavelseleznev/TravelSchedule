//
//  SettingsButton.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/12/25.
//

import SwiftUI

struct SettingsButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
    }
}
