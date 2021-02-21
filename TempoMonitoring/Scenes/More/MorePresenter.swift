//
//  MorePresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class MorePresenter: MorePresenterProtocol {
    private var faqUrl: String?
    private var supportUrl: String?
    private var tutorialUrl: String?
    private var webUrl: String?
    let configRepository: ConfigRepositoryProtocol
    var userRepository: UserRepositoryProtocol
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let keychainHandler: KeychainHandlerProtocol
    var view: MoreTableViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, userDefaultsHandler: UserDefaultsHandlerProtocol, keychainHandler: KeychainHandlerProtocol, view: MoreTableViewControllerProtocol) {
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.userDefaultsHandler = userDefaultsHandler
        self.keychainHandler = keychainHandler
        self.view = view
    }
    
    func didSelect(type: MoreOptionType) {
        switch type {
        case .laus:
            view.open(webUrl)
        case .support:
            guard let supportUrl = supportUrl else {
                view.open(nil)
                return
            }
            let url = (supportUrl.contains("http")) ? supportUrl : "https://api.whatsapp.com/send?phone=\(supportUrl)&text="
            view.open(url)
        case .tutorial:
            view.open(tutorialUrl)
        case .faq:
            view.open(faqUrl)
        case .signOut:
            view.showQuestion(.alert, message: Constants.Localizable.SIGN_OUT_QUESTION) { [weak self] (isSuccessful) in
                guard let self = self, isSuccessful else { return }

                self.userDefaultsHandler.remove(from: Constants.Keys.IS_NOTIFICATION_ENABLED)
                _ = self.keychainHandler.remove(from: Constants.Keys.TOKEN)
                _ = self.keychainHandler.remove(from: Constants.Keys.COMPANY_TOKEN)
                _ = self.keychainHandler.remove(from: Constants.Keys.DOCUMENT_TYPE_ID)
                _ = self.keychainHandler.remove(from: Constants.Keys.DOCUMENT)
                _ = self.keychainHandler.remove(from: Constants.Keys.PASSWORD)
                self.userRepository.currentCompany = nil
                self.userRepository.unregisterDevice()
                self.view.goToFirstScene()
            }
        }
    }
    
    func getBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return UIColor(company.primaryColor)
    }
    
    func getImageOptions() -> (imageUrl: String, color: String?)? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return (company.logoUrl, company.logoBackgroundColor)
    }
    
    func loadOptions() -> [(image: UIImage, type: MoreOptionType, title: String)] {
        return [
            (#imageLiteral(resourceName: "phoneButton.png"), .laus, Constants.Localizable.WHAT_IS_LAUS),
            (#imageLiteral(resourceName: "callButton.png"), .support, Constants.Localizable.SUPPORT_CHAT),
            (#imageLiteral(resourceName: "helpButton.png"), .tutorial, Constants.Localizable.TUTORIAL),
            (#imageLiteral(resourceName: "helpButton.png"), .faq, Constants.Localizable.FAQ),
            (#imageLiteral(resourceName: "settingsButton.png"), .signOut, Constants.Localizable.SIGN_OUT)
        ]
    }
    
    func loadResources(withProgress progress: Bool) {
        if progress {
            view.startProgress()
        }
        
        configRepository.getResourceLinks(success: { [weak self] (faqUrl, tutorialUrl, webUrl, supportUrl) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.faqUrl = faqUrl
            self.tutorialUrl = tutorialUrl
            self.webUrl = webUrl
            self.supportUrl = supportUrl
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
