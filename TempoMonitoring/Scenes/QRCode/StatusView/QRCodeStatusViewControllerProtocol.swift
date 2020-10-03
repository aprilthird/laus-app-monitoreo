//
//  QRCodeStatusViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol QRCodeStatusViewControllerProtocol: AlertHandlerProtocol {
    var isPopupHidden: Bool { get set }
    
    func closeView()
    func updatePopup(_ title: String?, _ subtitle: String?, _ image: UIImage, _ authorization: String, _ description: String?)
}
