//
//  AlertHandlerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol AlertHandlerProtocol {
    func show(_ style: UIAlertController.Style, title: String?, message: String, closure: @escaping(() -> Void))
}
extension AlertHandlerProtocol {
    func show(_ style: UIAlertController.Style, message: String, closure: (() -> Void)? = nil) {
        show(style, title: Constants.Localizable.APP_NAME, message: message) {
            closure?()
        }
    }
}
