//
//  LinkNavigator.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 7/20/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

class LinkNavigator {
    static let shared = LinkNavigator()
    
    func displayAction(_ type: LinkType?) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.displayAction(type)
            }
            return
        }
        let navigationController = rootViewController.selectedViewController as? UINavigationController
        
        switch type {
        case .attention:
            navigationController?.popToRootViewController(animated: false)
            rootViewController.selectedIndex = 2
        default:
            break
        }
    }
}
