//
//  UIViewExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    private static var NIBName: String {
        return String(describing: self)
    }
    
    static func get(owner: Any? = nil) -> Self {
        guard let view = Bundle.main.loadNibNamed(NIBName, owner: owner, options: nil)?[0] as? Self else {
            fatalError("This should never happen")
        }
        return view
    }
    
    static func getNIB() -> UINib {
        return UINib(nibName: self.NIBName, bundle: nil)
    }
}
