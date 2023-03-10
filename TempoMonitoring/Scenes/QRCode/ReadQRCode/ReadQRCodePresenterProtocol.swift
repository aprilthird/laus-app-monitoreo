//
//  ReadQRCodePresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol ReadQRCodePresenterProtocol {
    func getCloseButtonBackgroundColor() -> UIColor?
    func isQRCodeValid(_ string: String?) -> Bool
}
