//
//  RouterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol RouterProtocol {
    func getTempoNavigationController(_ rootViewController: UIViewController) -> UINavigationController
    func getContactUsPopup() -> UIViewController
    func getFirstScene() -> UIViewController
    func getMainTabBar() -> UIViewController
    func getMainWebView(url: String) -> UIViewController
    func getSignIn() -> UIViewController
    func getSplash() -> UIViewController
}
