//
//  LinkManager.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 7/20/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

class LinkManager {
    static let shared = LinkManager()
    
    func handleLink(url:URL, isUniversalLink: Bool) -> Bool {
        let deeplinkType = parseDeeplink(url, isUniversalLink)
        
        LinkNavigator.shared.displayAction(deeplinkType)
        
        return deeplinkType != nil
    }
    
    // MARK: Deeplink
    private func parseDeeplink(_ url: URL, _ isUniversalLink: Bool = false) -> LinkType? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = urlComponents.host else {
                return nil
        }
        var pathComponents = urlComponents.path.components(separatedBy: "/")
        pathComponents.removeFirst()
        let component = (isUniversalLink) ? pathComponents.first : host
        
        switch component {
        case "attention":
            return LinkType.attention
        default:
            return nil
        }
    }
}
