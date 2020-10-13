//
//  QRCodeStatusPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol QRCodeStatusPresenterProtocol {
    func getCloseButtonBackgroundColor() -> UIColor?
    func getPopupBackgroundColor() -> UIColor?
    func loadPopup(access: Bool?, name: String?, date: String?, text: String?)
}
