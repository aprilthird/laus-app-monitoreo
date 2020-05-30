//
//  UIViewControllerExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    private static var NIBName: String {
        return String(describing: self)
    }
    
    static func get(with bundle: Bundle? = nil) -> Self {
        return Self(nibName: NIBName, bundle: bundle)
    }
    
    // MARK: Alert controller
    func show(_ style: UIAlertController.Style, title: String? = Constants.Localizable.APP_NAME, message: String, closure: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: Constants.Localizable.OK, style: .default) { (_) in
            closure?()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
