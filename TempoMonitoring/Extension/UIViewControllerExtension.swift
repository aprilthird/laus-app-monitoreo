//
//  UIViewControllerExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController: AlertHandlerProtocol, HUDHandlerProtocol {
    private static var NIBName: String {
        return String(describing: self)
    }
    
    static func get(with bundle: Bundle? = nil) -> Self {
        return Self(nibName: NIBName, bundle: bundle)
    }
    
    func show(_ style: UIAlertController.Style, title: String?, message: String, closure: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: Constants.Localizable.OK, style: .default) { (_) in
            closure()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func startProgress(message: String?, with maskType: SVProgressHUDMaskType) {
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.show(withStatus: message)
    }
    
    func endProgress() {
        SVProgressHUD.dismiss()
    }
}
