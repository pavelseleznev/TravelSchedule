//
//  WebAgreementView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/2/25.
//

import SwiftUI
import WebKit

struct WebAgreementView: UIViewRepresentable {
    
    // MARK: - Property & Environment
    let url: URL
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let web = WKWebView(frame: .zero, configuration: config)
        web.scrollView.contentInsetAdjustmentBehavior = .never
        return web
    }
    
    func updateUIView(_ web: WKWebView, context: Context) {
        context.coordinator.applyTheme(on: web, scheme: colorScheme)
        if web.url == nil { web.load(URLRequest(url: url)) }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
}
