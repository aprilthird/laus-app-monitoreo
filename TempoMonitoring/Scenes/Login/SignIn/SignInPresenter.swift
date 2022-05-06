//
//  SignInPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class SignInPresenter: SignInPresenterProtocol {
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let view: SignInViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, view: SignInViewControllerProtocol) {
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func didLoadSignUpLogic() {
        configRepository.getSignUpUrl(success: { [weak self] (url, visibility) in
            guard let self = self else { return }
            
            self.view.updateView(url: url, visibility: visibility)
        }) { (error) in
        }
    }
    
    func goToCompanySelection(documentTypeId: Int, documentType: String, document: String) {
        self.view.startProgress()
        userRepository.getUserCompanies(documentType: documentType,
                                        document: document,
                                        success: { [weak self] (userCompanies) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.userRepository.registerDevice()
            self.configRepository.saveDeviceIdentifier()
            self.view.endProgress()
            
            self.view.goToCompanySelection(documentTypeId, document, userCompanies)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            if NetworkStatus.shared.isOn {
                self.view.show(.alert, message: error.localizedDescription)
            }
        }
    }
    
    func validateKeyboard(text: String?) -> UIKeyboardType {
        switch text?.lowercased() {
        case DocumentTypeEnum.dni.rawValue.lowercased(): return .numberPad
        default: return .default
        }
    }
}
