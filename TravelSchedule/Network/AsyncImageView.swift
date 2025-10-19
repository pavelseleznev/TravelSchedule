//
//  AsyncImageView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/15/25.
//

import SwiftUI

struct AsyncImageView: View {
    
    // MARK: - Public Properties
    let url: String?
    let placeholder: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let fallbackSystemImageName: String?
    
    // MARK: - View state
    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var loadingFailed = false
    
    // MARK: - Body
    var body: some View {
        Group {
            // Successful decode → show the real image
            if let data = imageData, !loadingFailed, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            } else if isLoading {
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView()
                        .scaleEffect(0.8)
                }
                
                // Failure or nothing to show → fallback asset or SF Symbol
            } else {
                if !placeholder.isEmpty, UIImage(named: placeholder) != nil {
                    Image(placeholder)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "train.side.front.car")
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onAppear { loadImage()
        }
        .onChange(of: url) {
            loadImage()
        }
        .onDisappear {
            imageData = nil
            isLoading = false
        }
    }
    
    // MARK: - Image loading
    private func loadImage() {
        // Invalid or empty URL → mark failure so placeholder shows
        guard let urlString = url, !urlString.isEmpty, let imageUrl = URL(string: urlString) else {
            loadingFailed = true
            isLoading = false
            imageData = nil
            return
        }
        
        // Quick URL-based SVG check → use placeholder instead
        if urlString.lowercased().hasSuffix(".svg") {
            loadingFailed = true
            isLoading = false
            imageData = nil
            return
        }
        
        imageData = nil
        loadingFailed = false
        isLoading = true
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: imageUrl)
                
                let okStatus = (response as? HTTPURLResponse)?.statusCode == 200
                let isSVG = response.mimeType?.lowercased().contains("svg") == true
                
                if okStatus, !data.isEmpty, !isSVG, UIImage(data: data) != nil {
                    await MainActor.run {
                        self.imageData = data
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.loadingFailed = true
                        self.isLoading = false
                        self.imageData = nil
                    }
                }
            } catch {
                await MainActor.run {
                    self.loadingFailed = true
                    self.isLoading = false
                    self.imageData = nil
                }
            }
        }
    }
}
