//
//  QRCodeStatusPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class QRCodeStatusPresenter: QRCodeStatusPresenterProtocol {
    let userRepository: UserRepositoryProtocol
    var view: QRCodeStatusViewControllerProtocol
    
    init(userRepository: UserRepositoryProtocol, view: QRCodeStatusViewControllerProtocol) {
        self.userRepository = userRepository
        self.view = view
    }
    
    func getCloseButtonBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return UIColor(company.accentColor)
    }
    
    func getPopupBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return UIColor(company.primaryColor)
    }
    
    func loadPopup(access: Bool?, name: String?) {
        guard let access = access else {
            view.updatePopup(Constants.Localizable.INVALID_CODE, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED)
            return
        }
        
        if access {
            view.updatePopup(name, #imageLiteral(resourceName: "authorizedImage.png"), Constants.Localizable.AUTHORIZED)
        } else {
            view.updatePopup(name, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED)
        }
    }
}
