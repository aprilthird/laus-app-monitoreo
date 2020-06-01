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
    
    func loadPopup(status: QRCodeStatus?, name: String?) {
        switch status {
        case .authorized, .unauthorized:
            view.updatePopup(name, (status == .authorized) ? #imageLiteral(resourceName: "authorizedImage.png") : #imageLiteral(resourceName: "unauthorizedImage.png"), (status == .authorized) ? Constants.Localizable.AUTHORIZED : Constants.Localizable.UNAUTHORIZED)
        case .invalidCode:
            view.updatePopup(Constants.Localizable.INVALID_CODE, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED)
        default:
            view.isPopupHidden = true
            view.show(.alert, message: Constants.Localizable.DEFAULT_ERROR_MESSAGE) {
                self.view.closeView()
            }
        }
    }
}
