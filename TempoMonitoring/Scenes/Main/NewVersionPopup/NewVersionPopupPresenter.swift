//
//  NewVersionPopupPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class NewVersionPopupPresenter: NewVersionPopupPresenterProtocol {
    var userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func getBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return UIColor(company.primaryColor)
    }
    
    func getButtonBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return UIColor(company.accentColor)
    }
}
