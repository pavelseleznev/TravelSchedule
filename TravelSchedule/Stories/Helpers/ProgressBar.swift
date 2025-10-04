//
//  ProgressBar.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/29/25.
//

import SwiftUI

struct ProgressBar: View {
    
    // MARK: - Configuration
    let numberOfSections: Int
    let progress: CGFloat
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: .progressBarHeight)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: .progressBarHeight)
                    .foregroundColor(.blueUniversal)
            }
            .mask {
                MaskView(numberOfSections: numberOfSections)
            }
        }
    }
}

struct MaskView: View {
    
    // MARK: - Configuration
    let numberOfSections: Int
    
    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
        
    }
}

struct MaskFragmentView: View {
    
    // MARK: - Body
    var body: some View {
        RoundedRectangle(cornerRadius: .progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: .progressBarHeight)
            .foregroundColor(.white)
    }
}

extension CGFloat {
    static let progressBarCornerRadius: CGFloat = 6
    static let progressBarHeight: CGFloat = 6
}

#Preview {
    ProgressBar(numberOfSections: 5, progress: 0.5)
        .padding()
}
