//
//  SearchBar.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 8/1/25.
//

import SwiftUI

struct SearchBar: View {
    
    // MARK: - Binding & Environment
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(text.isEmpty ? .grayUniversal : .blackDayNight)
                .padding(.leading, 8)
                .accessibilityHidden(true)
            TextField("Введите запрос", text: $text)
                .padding(8)
                .padding(.trailing, 8)
                .foregroundColor(.blackDayNight)
                .accessibilityLabel("Поиск")
                .accessibilityHint("Введите название города или станции")
                .accessibilityValue(text)
                .accessibilitySortPriority(1)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: { text = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.grayUniversal)
                            }
                            .padding(.trailing, 6)
                            .accessibilityLabel("Очистить поисковую строку")
                            .accessibilitySortPriority(0)
                        }
                    }
                )
        }
        .background(colorScheme == .dark ? .fillsTertiaryDark : .lightGrayUniversal)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

#Preview {
    struct SearchBarPreview: View {
        @State private var searchText = ""
        
        var body: some View {
            SearchBar(text: $searchText)
        }
    }
    return SearchBarPreview()
}
