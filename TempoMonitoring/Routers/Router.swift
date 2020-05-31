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
    private let keychainHandler: KeychainHandlerProtocol
    private let userDefaultsHandler: UserDefaultsHandler
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    init() {
        keychainHandler = KeychainHandler()
        userDefaultsHandler = UserDefaultsHandler()
        configRepository = ConfigRepository(keychainHandler: keychainHandler, userDefaultsHandler: userDefaultsHandler)
        userRepository = UserRepository()
    }
    
    func getTempoNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.barTintColor = UIColor("#6B9DF2")
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        return navigationController
    }
    
    func getContactUsPopup() -> UIViewController {
        let viewController = ContactUsPopupViewController.get()
        viewController.contactUsPresenter = ContactUsPopupPresenter(userRepository: userRepository, view: viewController)
        return viewController
    }
    
    func getFirstScene() -> UIViewController {
        let viewController = FirstSceneViewController.get()
        viewController.firstScenePresenter = FirstScenePresenter(configRepository: configRepository, view: viewController)
        return viewController
    }
    
    func getMainTabBar() -> UIViewController {
        let viewController = MainTabBarController.get()
        return viewController
    }
    
    func getMainWebView(url: String) -> UIViewController {
        let viewController = MainWebViewViewController.get()
        viewController.url = url
        return viewController
    }
    
    func getSignIn() -> UIViewController {
        let viewController = SignInViewController.get()
        return viewController
    }
    
    func getSplash() -> UIViewController {
        let viewController = SplashViewController.get()
        viewController.splashPresenter = SplashPresenter(view: viewController)
        return viewController
    }
}
