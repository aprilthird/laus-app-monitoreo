//
//  CompanySelectionPresenter.swift
//  TempoMonitoring
//
//  Created by Luis Jeffrey Rojas Montes on 17/04/22.
//  Copyright © 2022 Sportafolio SAC. All rights reserved.
//

import Foundation

final class CompanySelectionPresenter: CompanySelectionPresenterProtocol {
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let view: CompanySelectionViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, view: CompanySelectionViewControllerProtocol) {
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func signIn(documentTypeId: Int, document: String, companyId: String) {
        view.startProgress()
        userRepository.signIn(documentTypeId: documentTypeId,
                              document: document,
                              companyId: companyId,
                              password: nil,
        success: { [weak self] (isSuccessful, isPasswordRequired) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            guard !isPasswordRequired else {
                self.view.goToPasswordSignIn(documentTypeId, document, companyId)
                return
            }
            
            self.userRepository.registerDevice()
            self.configRepository.saveDeviceIdentifier()
            self.view.goToMain()
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
