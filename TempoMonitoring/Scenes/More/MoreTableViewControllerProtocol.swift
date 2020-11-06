//
//  MoreTableViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

enum MoreOptionType: String {
    case laus
    case support
    case tutorial
    case faq
    case signOut
}

protocol MoreTableViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func goToFirstScene()
    func open(_ url: String?)
}
