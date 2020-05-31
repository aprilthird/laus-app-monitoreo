//
//  AttentionViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol AttentionViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func openUrl(_ url: String)
    func showMoreSection()
}
