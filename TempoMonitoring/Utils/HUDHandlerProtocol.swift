//
//  HUDHandlerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol HUDHandlerProtocol {
    var isHUDVisible: Bool { get }
    func endProgress()
    func startProgress(message: String?, with maskType: SVProgressHUDMaskType)
}
extension HUDHandlerProtocol {
    func startProgress(message: String? = nil) {
        startProgress(message: message, with: .black)
    }
    
    func startProgress(with maskType: SVProgressHUDMaskType) {
        startProgress(message: nil, with: maskType)
    }
}
