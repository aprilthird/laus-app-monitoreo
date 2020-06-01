//
//  TipsCollectionViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol TipsCollectionViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func openWebView(_ url: String)
    func updateTips(_ options: [(imageUrl: String, name: String, url: String)])
}
