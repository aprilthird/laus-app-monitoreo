//
//  TriageViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol TriageViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func showQRCodeReader()
    func showWebView(_ title: String?, _ url: String)
    func updateLastTriage(_ isHidden: Bool, _ attributedText: NSAttributedString?)
}
