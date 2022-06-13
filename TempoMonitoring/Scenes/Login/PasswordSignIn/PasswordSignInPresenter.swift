//
//  PasswordSignInPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Rosado on 11/1/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class PasswordSignInPresenter: PasswordSignInPresenterProtocol {
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let view: PasswordSignInViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, view: PasswordSignInViewControllerProtocol) {
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func forgotPassword(documentTypeId: Int, document: String, companyId: String) {
        view.startProgress()
        userRepository.recoverPassword(documentTypeId: documentTypeId, document: document, companyId: companyId, success: { [weak self] (imageUrl, message) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.goToForgotPasswordPopup(imageUrl, message)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            if NetworkStatus.shared.isOn {
                self.view.show(.alert, message: error.localizedDescription)
            }
        }
    }
    
    func signIn(documentTypeId: Int, document: String, companyId: String, password: String) {
        view.startProgress()
        userRepository.signIn(documentTypeId: documentTypeId,
                              document: document,
                              companyId: companyId,
                              password: password,
        success: { [weak self] (isSuccessful, _) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.userRepository.registerDevice()
            self.configRepository.saveDeviceIdentifier()
            self.view.goToMain()
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            if NetworkStatus.shared.isOn {
                self.view.show(.alert, message: error.localizedDescription)
            }
        }
    }
}
