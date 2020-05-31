//
//  ReadQRCodeViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

enum QRCodeStatus: Int {
    case unauthorized
    case authorized
    case invalidCode
}

protocol ReadQRCodeViewControllerProtocol {
    func showQRCodeStatus(_ status: QRCodeStatus?, _ name: String?, _ date: String?)
}
