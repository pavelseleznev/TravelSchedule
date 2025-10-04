//
//  StoryView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/27/25.
//

import SwiftUI
import Combine

struct StoryView: View {
    
    // MARK: - ViewModel & Environment
    @ObservedObject var viewModel: StoriesViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.blackUniversal.edgesIgnoringSafeArea(.all)
            
            Image(viewModel.story[viewModel.currentStoryIndex].images[viewModel.currentImageIndex])
                .resizable()
                .scaledToFit()
                .cornerRadius(40)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text("Text Text Text Text Text Text Text Text Text Text")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text("Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text")
                    .font(.system(size: 20, weight: .regular))
                    .lineLimit(3)
                    .foregroundColor(.white)
            }
            .padding(.init(top: 0, leading: 16, bottom: 40, trailing: 16))
            
            VStack {
                HStack(spacing: 4) {
                    ForEach(0..<viewModel.story[viewModel.currentStoryIndex].images.count, id: \.self) { index in
                        ProgressBar(
                            numberOfSections: 1,
                            progress: index == viewModel.currentImageIndex ? viewModel.progress : (index < viewModel.currentImageIndex ? 1 : 0)
                        )
                        .frame(height: 6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 35)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.stopTimer()
                        viewModel.showStoryView = false
                        dismiss()
                    }) {
                        Image(.closeButton)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(.top, 57)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.20)
                        .onTapGesture {
                            viewModel.switchToPreviousStory()
                        }
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: geometry.size.width * 0.50)
                    
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.20)
                        .onTapGesture {
                            viewModel.switchToNextStory()
                        }
                }
            }
            .ignoresSafeArea()
            
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 100 {
                            viewModel.stopTimer()
                            viewModel.showStoryView = false
                            dismiss()
                        }
                        else if value.translation.width < -50 {
                            viewModel.switchToNextStory()
                        }
                        else if value.translation.width > 50 {
                            viewModel.switchToPreviousStory()
                        }
                    }
            )
            .onChange(of: viewModel.showStoryView) { _, newValue in
                if !newValue {
                    dismiss()
                }
            }
            .onAppear {
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    StoryView(viewModel: StoriesViewModel())
}
