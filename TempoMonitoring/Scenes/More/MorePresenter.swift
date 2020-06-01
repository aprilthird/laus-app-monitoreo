//
//  MorePresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Keychain
import UIKit

final class MorePresenter: MorePresenterProtocol {
    let configRepository: ConfigRepositoryProtocol
    var userRepository: UserRepositoryProtocol
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    var view: MoreTableViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, userDefaultsHandler: UserDefaultsHandlerProtocol, view: MoreTableViewControllerProtocol) {
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.userDefaultsHandler = userDefaultsHandler
        self.view = view
    }
    
    func didSelect(option: (image: UIImage, type: MoreOptionType, title: String)) {
        switch option.type {
        case .tempo:
            view.open("https://temposalud.com/")
        case.support:
            view.open("https://api.whatsapp.com/send?phone=+51933440200&text=")
        case .tutorial:
            view.startProgress()
            
            configRepository.getTutorial(success: { (url) in
                self.view.endProgress()
                
                self.view.open(url)
            }) { (error) in
                self.view.endProgress()
                
                self.view.show(.alert, message: error.localizedDescription)
            }
        case .faq:
            view.startProgress()
            
            configRepository.getFAQs(success: { (url) in
                self.view.endProgress()
                
                self.view.open(url)
            }) { (error) in
                self.view.endProgress()
                
                self.view.show(.alert, message: error.localizedDescription)
            }
        case .signOut:
            view.showQuestion(.alert, message: Constants.Localizable.SIGN_OUT_QUESTION) {
                self.userDefaultsHandler.remove(from: Constants.Keys.IS_SCANNER_ENABLED)
                self.userRepository.currentCompany = nil
                _ = Keychain.delete(Constants.Keys.TOKEN)
                _ = Keychain.delete(Constants.Keys.COMPANY_TOKEN)
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
            (#imageLiteral(resourceName: "phoneButton.png"), .tempo, Constants.Localizable.WHAT_IS_TEMPO),
            (#imageLiteral(resourceName: "phoneButton.png"), .support, Constants.Localizable.SUPPORT_CHAT),
            (#imageLiteral(resourceName: "helpButton.png"), .tutorial, Constants.Localizable.TUTORIAL),
            (#imageLiteral(resourceName: "helpButton.png"), .faq, Constants.Localizable.FAQ),
            (#imageLiteral(resourceName: "settingsButton.png"), .signOut, Constants.Localizable.SIGN_OUT)
        ]
    }
}