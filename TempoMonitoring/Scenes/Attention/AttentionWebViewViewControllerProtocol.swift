//
//  AttentionWebViewViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol AttentionWebViewViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func goBack()
    func openUrl(_ url: String)
    func showMoreSection()
}
