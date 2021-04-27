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
    
    func loadPopup(access: Bool?, name: String?, date: String?, text: String?) {
        guard let access = access else {
            view.updatePopup(Constants.Localizable.INVALID_CODE, nil, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED, nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.utc
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        var formattedDate: String? = nil
        var isDateAvailable: Bool = false
        if let date = date, let aux = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let stringDate = dateFormatter.string(from: aux)
            dateFormatter.dateFormat = "HH:mm"
            let stringTime = dateFormatter.string(from: aux)
            formattedDate = "\(stringDate) a las \(stringTime)"
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: aux)
            isDateAvailable = newDate?.compare(Date()) == .orderedDescending
        }
        if access {
            if isDateAvailable {
                view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "authorizedImage.png"), Constants.Localizable.SUITABLE, text)
            } else {
                view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "warningImage"), Constants.Localizable.PAST_DATE, Constants.Localizable.PAST_DATE_24_HOURS)
            }
        } else {
            view.updatePopup(name, formattedDate, #imageLiteral(resourceName: "unauthorizedImage.png"), Constants.Localizable.UNAUTHORIZED, nil)
        }
    }
}
