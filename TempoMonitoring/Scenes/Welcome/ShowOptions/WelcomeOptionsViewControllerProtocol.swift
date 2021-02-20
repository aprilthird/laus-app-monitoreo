//
//  WelcomeOptionsViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol WelcomeOptionsViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func updateOptions(_ options: [(String, String, String)])
}
