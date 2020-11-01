//
//  PasswordSignInViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Rosado on 11/1/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol PasswordSignInViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func goToForgotPasswordPopup(_ imageUrl: String?, _ message: String)
    func goToMain()
}
