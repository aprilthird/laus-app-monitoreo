//
//  Router.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class Router: RouterProtocol {
    static let shared: Router = Router()
    
    init() {
    }
    
    func getFirstScene() -> UIViewController {
        let viewController = FirstSceneViewController.get()
        return viewController
    }
    
    func getMainTabBar() -> UIViewController {
        let viewController = MainTabBarController.get()
        return viewController
    }
    
    func getSignIn() -> UIViewController {
        let viewController = SignInViewController.get()
        return viewController
    }
    
    func getSplash() -> UIViewController {
        let viewController = SplashViewController.get()
        return viewController
    }
}
