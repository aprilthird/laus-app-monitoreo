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
    func showQuestion(_ style: UIAlertController.Style, title: String?, message: String, yes okTitle: String, no cancelTitle: String, closure: @escaping(() -> Void))
}
extension AlertHandlerProtocol {
    func show(_ style: UIAlertController.Style, message: String, closure: (() -> Void)? = nil) {
        show(style, title: nil, message: message) {
            closure?()
        }
    }
    
    func showQuestion(_ style: UIAlertController.Style, message: String, yes yesTitle: String, no noTitle: String, closure: (() -> Void)? = nil) {
        showQuestion(style, title: nil, message: message, yes: yesTitle, no: noTitle) {
            closure?()
        }
    }
    
    func showQuestion(_ style: UIAlertController.Style, message: String, closure: @escaping(() -> Void)) {
        showQuestion(style, title: nil, message: message, yes: Constants.Localizable.YES, no: Constants.Localizable.NO, closure: closure)
    }
}
