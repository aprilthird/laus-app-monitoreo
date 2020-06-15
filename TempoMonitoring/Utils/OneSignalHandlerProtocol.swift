//
//  OneSignalHandlerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 6/15/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import OneSignal
import UIKit

protocol OneSignalHandlerProtocol {
    func initialConfiguration(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func getAuthorizationStatus(closure: @escaping(UNAuthorizationStatus) -> Void)
}
extension OneSignalHandlerProtocol {
    func getAuthorizationStatus() {
        getAuthorizationStatus { (_) in
        }
    }
}
