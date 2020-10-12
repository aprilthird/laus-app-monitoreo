//
//  SplashPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class SplashPresenter: SplashPresenterProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let keychainHandler: KeychainHandlerProtocol
    let configRepository: ConfigRepositoryProtocol
    let generalRepository: GeneralRepositoryProtocol
    let view: SplashViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, keychainHandler: KeychainHandlerProtocol, configRepository: ConfigRepositoryProtocol, generalRepository: GeneralRepositoryProtocol, view: SplashViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.keychainHandler = keychainHandler
        self.configRepository = configRepository
        self.generalRepository = generalRepository
        self.view = view
    }
    
    func startAnimation() {
        configRepository.getDocumentType { [weak self] (_) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.validateLogin()
            }
        }
    }
    
    private func validateLogin() {
        guard userDefaultsHandler.bool(from: Constants.Keys.WAS_FIRST_OPEN),
            let _ = keychainHandler.string(from: Constants.Keys.TOKEN),
            let _ = keychainHandler.string(from: Constants.Keys.COMPANY_TOKEN) else {
                userDefaultsHandler.save(value: true, to: Constants.Keys.WAS_FIRST_OPEN)
                _ = keychainHandler.remove(from: Constants.Keys.TOKEN)
                _ = keychainHandler.remove(from: Constants.Keys.COMPANY_TOKEN)
                view.goToFirstScene()
                return
        }
        view.goToMain()
    }
}
