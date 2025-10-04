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
    
    // MARK: - Coordinator
    final class Coordinator {
        private var lastScheme: ColorScheme?
        
        // MARK: - Theme Handling
        func applyTheme(on web: WKWebView, scheme: ColorScheme) {
            guard lastScheme != scheme else { return }
            lastScheme = scheme
            
            let userContentController = web.configuration.userContentController
            userContentController.removeAllUserScripts()
            if scheme == .dark {
                userContentController.addUserScript(WKUserScript(
                    source: Self.darkJS,
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true))
            }
            if web.url != nil { web.reloadFromOrigin() }
        }
        
        // MARK: - Dark Mode Injection
        static let darkCSS = """
        * { background: #181A20 !important; color: #fff !important; border-color: #444 !important; box-shadow: none !important; }
        a { color: #89aaff !important; }
        """
        
        static let darkJS = """
        var style = document.createElement('style');
        style.innerHTML = `\(darkCSS)`;
        document.head.appendChild(style);
        """
    }
}
