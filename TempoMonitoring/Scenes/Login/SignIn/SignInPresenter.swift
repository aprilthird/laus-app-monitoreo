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
        configRepository.getSignUpUrl(success: { (url, visibility) in
            self.view.updateView(url: url, visibility: visibility)
        }) { (error) in
        }
    }
    
    func signIn(documentTypeId: Int, document: String) {
        view.startProgress()
        userRepository.signIn(documentTypeId: documentTypeId,
                              document: document,
        success: { (isSuccessful) in
            self.view.endProgress()
            
            self.userRepository.registerDevice()
            self.view.goToMain()
        }) { (error) in
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
    
    func validateKeyboard(text: String?) -> UIKeyboardType {
        switch text?.lowercased() {
        case DocumentTypeEnum.dni.rawValue.lowercased(): return .numberPad
        default: return .default
        }
    }
}
