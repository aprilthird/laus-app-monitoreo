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
        userRepository = UserRepository(userDefaultsHandler: userDefaultsHandler)
    }
    
    func getAttention() -> UIViewController {
        let viewController = AttentionWebViewViewController.get()
        return viewController
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
        viewController.mainPresenter = MainPresenter(userRepository: userRepository,
                                                     configRepository: configRepository,
                                                     userDefaultsHandler: userDefaultsHandler,
                                                     view: viewController)
        viewController.loadTabBar()
        return viewController
    }
    
    func getMainWebView(title: String?, url: String) -> UIViewController {
        let viewController = MainWebViewViewController.get()
        viewController.navigationTitle = title
        viewController.url = url
        return viewController
    }
    
    func getSignIn(shouldSignUpUser: Bool?, signUpUrl: String?) -> UIViewController {
        let viewController = SignInViewController.get()
        viewController.signInPresenter = SignInPresenter(configRepository: configRepository, userRepository: userRepository, view: viewController)
        viewController.shouldSignUpUser = shouldSignUpUser
        viewController.signUpUrl = signUpUrl
        return viewController
    }
    
    func getSplash() -> UIViewController {
        let viewController = SplashViewController.get()
        viewController.splashPresenter = SplashPresenter(view: viewController)
        return viewController
    }
    
    func getTempoNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let company = userRepository.currentCompany
        navigationController.navigationBar.barTintColor = UIColor(company?.primaryColor ?? "#6B9DF2")
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = true
        return navigationController
    }
    
    func getTips() -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func getTriage() -> UIViewController {
        let viewController = TriageViewController.get()
        return viewController
    }
}
