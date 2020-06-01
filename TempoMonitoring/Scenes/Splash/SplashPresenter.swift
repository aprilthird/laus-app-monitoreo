//
//  SplashPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Keychain

final class SplashPresenter: SplashPresenterProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let generalRepository: GeneralRepositoryProtocol
    let view: SplashViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, generalRepository: GeneralRepositoryProtocol, view: SplashViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.generalRepository = generalRepository
        self.view = view
    }
    
    func startAnimation() {
        generalRepository.saveLastVersionInAppStore {
            self.validateLogin()
        }
    }
    
    private func validateLogin() {
        guard userDefaultsHandler.bool(from: Constants.Keys.IS_FIRST_OPEN),
            let _ = Keychain.load(Constants.Keys.TOKEN),
            let _ = Keychain.load(Constants.Keys.COMPANY_TOKEN) else {
                userDefaultsHandler.save(value: true, to: Constants.Keys.IS_FIRST_OPEN)
                _ = Keychain.delete(Constants.Keys.TOKEN)
                _ = Keychain.delete(Constants.Keys.COMPANY_TOKEN)
                view.goToFirstScene()
                return
        }
        
        view.goToMain()
    }
}
