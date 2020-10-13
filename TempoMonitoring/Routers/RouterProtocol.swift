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
    func getAttention() -> UIViewController
    func getContactUsPopup() -> UIViewController
    func getFirstScene() -> UIViewController
    func getHomeBannerPopup(imageUrl: String, url: String) -> UIViewController
    func getMainTabBar() -> UIViewController
    func getMainWebView(title: String?, url: String) -> UIViewController
    func getMoreSection() -> UIViewController
    func getNewVersionPopup() -> UIViewController
    func getQRCodeReader() -> UIViewController
    func getQRCodeStatus(access: Bool?, name: String?, date: String?, description: String?) -> UIViewController
    func getSignIn(shouldSignUpUser: Bool?, signUpUrl: String?) -> UIViewController
    func getSplash() -> UIViewController
    func getTempoNavigationController(_ rootViewController: UIViewController) -> UINavigationController
    func getTips() -> UIViewController
    func getTriage() -> UIViewController
}
