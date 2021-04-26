//
//  ContactUsPopupPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class ContactUsPopupPresenter: ContactUsPopupPresenterProtocol {
    let userRepository: UserRepositoryProtocol
    let view: ContactUsPopupViewControllerProtocol
    
    init(userRepository: UserRepositoryProtocol, view: ContactUsPopupViewControllerProtocol) {
        self.userRepository = userRepository
        self.view = view
    }
    
    func sendInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, description: String, closure: @escaping(() -> Void)) {
        view.startProgress()
        userRepository.saveUserInformation(names: names,
                                           lastNames: lastNames,
                                           company: company,
                                           documentTypeId: documentTypeId,
                                           document: document,
                                           phone: phone,
                                           description: description,
        success: { [weak self] (isSuccessful) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: Constants.Localizable.SEND_INFORMATION_SUCCESFULLY) {
                closure()
            }
        }) { [weak self] (error) in
            guard let self = self else { return }
            
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
