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
    
    func loadPopup(access: Bool?, name: String?, date: String?) {
        guard let access = access else {
            view.updatePopup(Constants.Localizable.INVALID_CODE, nil, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        var formattedDate: String? = nil
        var isDateAvailable: Bool = false
        if let date = date, let aux = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            formattedDate = dateFormatter.string(from: aux)
            isDateAvailable = (aux.compare(Date()) == .orderedDescending) ? true : false
        }
        if access {
            if isDateAvailable {
                view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "authorizedImage.png"), Constants.Localizable.AUTHORIZED)
            } else {
                view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "warningImage"), Constants.Localizable.PAST_DATE)
            }
        } else {
            view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED)
        }
    }
}
