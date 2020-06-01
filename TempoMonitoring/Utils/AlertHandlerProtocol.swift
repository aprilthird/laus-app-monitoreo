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
    func showQuestion(_ style: UIAlertController.Style, title: String?, message: String, ok okTitle: String, cancel cancelTitle: String, closure: @escaping(() -> Void))
}
extension AlertHandlerProtocol {
    func show(_ style: UIAlertController.Style, message: String, closure: (() -> Void)? = nil) {
        show(style, title: nil, message: message) {
            closure?()
        }
    }
    
    func showQuestion(_ style: UIAlertController.Style, message: String, ok okTitle: String, cancel cancelTitle: String, closure: (() -> Void)? = nil) {
        showQuestion(style, title: nil, message: message, ok: okTitle, cancel: cancelTitle) {
            closure?()
        }
    }
    
    func showQuestion(_ style: UIAlertController.Style, message: String, closure: @escaping(() -> Void)) {
        showQuestion(style, title: nil, message: message, ok: Constants.Localizable.OK, cancel: Constants.Localizable.CANCEL, closure: closure)
    }
}
