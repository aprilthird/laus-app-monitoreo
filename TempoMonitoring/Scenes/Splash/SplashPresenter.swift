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
    let userRepository: UserRepositoryProtocol
    let view: SplashViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, keychainHandler: KeychainHandlerProtocol, configRepository: ConfigRepositoryProtocol, generalRepository: GeneralRepositoryProtocol, userRepository: UserRepositoryProtocol, view: SplashViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.keychainHandler = keychainHandler
        self.configRepository = configRepository
        self.generalRepository = generalRepository
        self.userRepository = userRepository
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard userDefaultsHandler.bool(from: Constants.Keys.WAS_FIRST_OPEN),
            let _ = keychainHandler.string(from: Constants.Keys.TOKEN),
            let _ = keychainHandler.string(from: Constants.Keys.COMPANY_TOKEN),
            let lastTokenUpdate = userDefaultsHandler.string(from: Constants.Keys.LAST_TOKENS_UPDATE) else {
                userDefaultsHandler.save(value: true, to: Constants.Keys.WAS_FIRST_OPEN)
                _ = keychainHandler.remove(from: Constants.Keys.TOKEN)
                _ = keychainHandler.remove(from: Constants.Keys.COMPANY_TOKEN)
                _ = keychainHandler.remove(from: Constants.Keys.DOCUMENT_TYPE_ID)
                _ = keychainHandler.remove(from: Constants.Keys.DOCUMENT)
                _ = keychainHandler.remove(from: Constants.Keys.PASSWORD)
                view.goToFirstScene()
                return
        }
        guard lastTokenUpdate != dateFormatter.string(from: Date()) else {
            view.goToMain()
            return
        }
        let document = keychainHandler.string(from: Constants.Keys.DOCUMENT) ?? ""
        let documentTypeId = keychainHandler.integer(from: Constants.Keys.DOCUMENT_TYPE_ID)
        let password = keychainHandler.string(from: Constants.Keys.PASSWORD)
        userRepository.signIn(documentTypeId: documentTypeId, document: document, password: password, success: { [weak self] (isSuccessful, isPasswordRequired) in
            guard !isPasswordRequired else {
                self?.view.goToFirstScene()
                return
            }
            self?.view.goToMain()
        }) { [weak self] (_) in
            self?.userDefaultsHandler.remove(from: Constants.Keys.LAST_TOKENS_UPDATE)
            self?.view.goToFirstScene()
        }
    }
}
