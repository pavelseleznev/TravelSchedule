//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct ErrorView: View {
    let errorType: ErrorType
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(errorType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .foregroundStyle(.grayUniversal)
            
            Text(errorType.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.blackDayNight)
                .padding(.top, 16)
            
            Spacer()
        }
    }
}

#Preview {
    ErrorView(
        errorType: .noInternet)
}
