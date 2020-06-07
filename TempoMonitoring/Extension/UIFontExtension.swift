//
//  UIFontExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 6/7/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

enum FamilyType: String {
    case thin = "-Thin"
    case light = "-Light"
    case regular = "-Regular"
    case medium = "-Medium"
    case bold = "-Bold"
    case black = "-Black"
}

extension UIFont {
    static func roboto(withType type: FamilyType, ofSize size: CGFloat) -> UIFont {
        let defaultFont = getDefaultFont("Roboto\(FamilyType.regular.rawValue)", type, size)
        
        guard let font = UIFont(name: "Roboto\(type.rawValue)", size: size) else {
            return defaultFont
        }
        return font
    }
    
    static func robotoCondensed(withType type: FamilyType, andSize size: CGFloat) -> UIFont {
        let defaultFont = getDefaultFont("RobotoCondensed\(FamilyType.regular.rawValue)", type, size)
        
        guard let font = UIFont(name: "RobotoCondensed\(type.rawValue)", size: size) else {
            return defaultFont
        }
        return font
    }
    
    private static func getDefaultFont(_ fontName: String, _ type: FamilyType, _ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            switch type {
            case .thin, .light, .regular:
                return .systemFont(ofSize: size)
            case .medium, .bold, .black:
                return .boldSystemFont(ofSize: size)
            }
        }
        return font
    }
}
