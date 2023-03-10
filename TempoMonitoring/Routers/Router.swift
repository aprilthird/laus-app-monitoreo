//
//  Router.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class Router {
    static let shared: Router = Router()
    private let keychainHandler: KeychainHandlerProtocol
    let oneSignalHandler: OneSignalHandlerProtocol
    private let userDefaultsHandler: UserDefaultsHandler
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let generalRepository: GeneralRepositoryProtocol
    private let tipRepository: TipRepositoryProtocol
    
    init() {
        keychainHandler = KeychainHandler()
        userDefaultsHandler = UserDefaultsHandler()
        configRepository = ConfigRepository(keychainHandler: keychainHandler, userDefaultsHandler: userDefaultsHandler)
        userRepository = UserRepository(userDefaultsHandler: userDefaultsHandler, keychainHandler: keychainHandler)
        oneSignalHandler = OneSignalHandler(userDefaultsHandler: userDefaultsHandler, userRepository: userRepository)
        generalRepository = GeneralRepository(userDefaultsHandler: userDefaultsHandler)
        tipRepository = TipRepository(keychainHandler: keychainHandler)
    }
    
    func getAttention() -> UIViewController {
        let viewController = AttentionWebViewViewController.get()
        viewController.attentionPresenter = AttentionWebViewPresenter(userDefaultsHandler: userDefaultsHandler, configRepository: configRepository, userRepository: userRepository, view: viewController)
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
    
    func getForgotPasswordPopup(imageUrl: String?, message: String) -> UIViewController {
        let viewController = ForgotPasswordPopupViewController.get()
        viewController.imageUrl = imageUrl
        viewController.message = message
        return viewController
    }
    
    func getHomeBannerPopup(imageUrl: String, url: String) -> UIViewController {
        let viewController = HomeBannerViewController.get()
        viewController.image = imageUrl
        viewController.url = url
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
    
    func getMoreSection() -> UIViewController {
        let viewController = MoreTableViewController.get()
        viewController.morePresenter = MorePresenter(configRepository: configRepository, userRepository: userRepository, userDefaultsHandler: userDefaultsHandler, keychainHandler: keychainHandler, view: viewController)
        return viewController
    }
    
    func getNewVersionPopup() -> UIViewController {
        let viewController = NewVersionPopupViewController.get()
        viewController.newVerionPresenter = NewVersionPopupPresenter(userRepository: userRepository)
        return viewController
    }
    
    func getPasswordSignIn(documentTypeId: Int, document: String, companyId: String) -> UIViewController {
        let viewController = PasswordSignInViewController.get()
        viewController.passwordSignInPresenter = PasswordSignInPresenter(configRepository: configRepository, userRepository: userRepository, view: viewController)
        viewController.documentTypeId = documentTypeId
        viewController.document = document
        viewController.companyId = companyId
        return viewController
    }
    
    func getCompanySelection(documentTypeId: Int, document: String, userCompanies: [(String, String)]) -> UIViewController {
        let viewController = CompanySelectionViewController.get()
        viewController.companySelectionPresenter = CompanySelectionPresenter(configRepository: configRepository, userRepository: userRepository, view: viewController)
        viewController.documentTypeId = documentTypeId
        viewController.document = document
        viewController.userCompanies = userCompanies
        return viewController
    }
    
    func getQRCodeReader() -> UIViewController {
        let viewController = ReadQRCodeViewController.get()
        viewController.readQRCodePresenter = ReadQRCodePresenter(userRepository: userRepository, view: viewController)
        return viewController
    }
    
    func getQRCodeStatus(access: Bool?, name: String?, date: String?, description: String?) -> UIViewController {
        let viewController = QRCodeStatusViewController.get()
        viewController.qrCodeStatusPresenter = QRCodeStatusPresenter(userRepository: userRepository, view: viewController)
        viewController.access = access
        viewController.name = name
        viewController.date = date
        viewController.text = description
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
        viewController.splashPresenter = SplashPresenter(userDefaultsHandler: userDefaultsHandler, keychainHandler: keychainHandler, configRepository: configRepository, generalRepository: generalRepository, userRepository: userRepository, view: viewController)
        return viewController
    }
    
    func getTempoNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let company = userRepository.currentCompany
        navigationController.navigationBar.barTintColor = UIColor(company?.primaryColor ?? "#6B9DF2")
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
    
    func getTips() -> UIViewController {
        let viewController = TipsCollectionViewController.get()
        viewController.tipsPresenter = TipsPresenter(tipRepository: tipRepository, userRepository: userRepository, view: viewController)
        return viewController
    }
    
    func getTriage() -> UIViewController {
        let viewController = TriageViewController.get()
        viewController.triagePresenter = TriagePresenter(userDefaultsHandler: userDefaultsHandler, configRepository: configRepository, view: viewController)
        return viewController
    }
    
    func getWelcomeOptions() -> UIViewController {
        let viewController = WelcomeOptionsViewController.get()
        viewController.presenter = WelcomeOptionsPresenter(userDefaultsHandler: userDefaultsHandler, configRepository: configRepository, userRepository: userRepository, view: viewController)
        return viewController
    }
    
    func getTriajeOffline() -> UIViewController {
        var viewController: UIViewController!
        
        let vcTriaje = UIStoryboard(name: "TriajeOfflineSB", bundle: nil).instantiateViewController(withIdentifier: "TriajeVC") as! TriajeOfflineViewController
        let vcDinamico = UIStoryboard(name: "TriajeOfflineSB", bundle: nil).instantiateViewController(withIdentifier: "TriajeDinamicoVC") as! TriajeDinamicoViewController
        
        let respuestaDao = RespuestasDao()
        let isCompleted = respuestaDao.triajeUnicoCompleto()
        if isCompleted {
            vcDinamico.presenter = TriajeDiarioPresenter()
            viewController = vcDinamico
        } else {
            vcTriaje.presenter = TriajeOfflinePresenter(view: vcTriaje)
            viewController = vcTriaje
        }
        
        return viewController
    }
    
    func showTriajeDiario() -> UIViewController {
        let vcDinamico = UIStoryboard(name: "TriajeOfflineSB", bundle: nil).instantiateViewController(withIdentifier: "TriajeDinamicoVC") as! TriajeDinamicoViewController
        vcDinamico.presenter = TriajeDiarioPresenter()
        return vcDinamico
    }
    
    func showOffline() -> UIViewController {
        let vcAlertOffline = OfflinePopupViewController.get()
//        vcAlertOffline.modalPresentationStyle = .fullScreen
        return vcAlertOffline
    }
}
