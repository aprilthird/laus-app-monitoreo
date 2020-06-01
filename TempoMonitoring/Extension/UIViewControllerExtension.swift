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
    
    // MARK: AlertHandlerProtocol
    func show(_ style: UIAlertController.Style, title: String?, message: String, closure: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title ?? Constants.Localizable.APP_NAME, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: Constants.Localizable.OK, style: .default) { (_) in
            closure()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showQuestion(_ style: UIAlertController.Style, title: String?, message: String, ok okTitle: String, cancel cancelTitle: String, closure: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title ?? Constants.Localizable.APP_NAME, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (_) in
            closure()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (_) in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: HUDHandlerProtocol
    var isHUDVisible: Bool {
        get {
            return SVProgressHUD.isVisible()
        }
    }
    
    func endProgress() {
        if isHUDVisible {
            SVProgressHUD.dismiss()
        }
    }
    
    func startProgress(message: String?, with maskType: SVProgressHUDMaskType) {
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.show(withStatus: message)
    }
    
    // MARK: Transition between viewControllers
    func crossDisolveTransition(to viewController: UIViewController, duration: TimeInterval = 0.6) {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError()
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: duration, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
}
