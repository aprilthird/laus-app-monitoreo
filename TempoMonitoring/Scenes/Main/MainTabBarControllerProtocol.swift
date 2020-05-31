//
//  MainTabBarControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol MainTabBarControllerProtocol: AlertHandlerProtocol {
    func showHomeBannerPopup(_ imageUrl: String, _ url: String)
    func showNewVersionPopup()
}
