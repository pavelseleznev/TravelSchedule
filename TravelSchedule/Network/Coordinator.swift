//
//  Coordinator.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 10/6/25.
//

import SwiftUI
import WebKit

// MARK: - Coordinator
@MainActor
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
