//
//  SignInViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol SignInViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func goToMain()
    func goToPasswordSignIn(_ documentTypeId: Int, _ document: String)
    func updateView(url: String, visibility: Bool)
}
