//
//  TriagePresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol TriagePresenterProtocol {
    func loadLastTriage(ofSize size: CGFloat) -> String
    func showQRCodeWebView()
    func getRightNavigationItems() -> [UIBarButtonItem]
    func showTriageWebView()
}
