//
//  UIColorExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

// MARK: Source from: https://github.com/mRs-/HexColors/blob/master/Sources/HexColors.swift
#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
  public typealias HexColor = UIColor
#else
  import Cocoa
  public typealias HexColor = NSColor
#endif

extension HexColor {
    convenience init?(_ hex: String, alpha: CGFloat? = nil) {
        guard let hexType = Type(from: hex), let components = hexType.components() else {
            return nil
        }
        
        #if os(iOS) || os(watchOS) || os(tvOS)
          self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha ?? components.alpha)
        #else
          self.init(calibratedRed: components.red, green: components.green, blue: components.blue, alpha: alpha ?? components.alpha)
        #endif
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var alpha, hue, saturation, brightness, red, green, blue, white: CGFloat
        (alpha, hue, saturation, brightness, red, green, blue, white) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        let multiplier = percentage / 100.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(max(red + multiplier * red, 0.0), 1.0),
                           green: min(max(green + multiplier * green, 0.0), 1.0),
                           blue: min(max(blue + multiplier * blue, 0.0), 1.0),
                           alpha: alpha)
        } else if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            if brightness < 1.0 {
                let newBrightness: CGFloat = max(min(brightness + multiplier * brightness, 1.0), 0.0)
                return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
            } else {
                let newSaturation: CGFloat = min(max(saturation - multiplier * saturation, 0.0), 1.0)
                return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
            }
        } else if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: white + multiplier * white, alpha: alpha)
        }
        return self
    }
    
    private enum `Type` {
      case RGBshort(rgb: String)
      case RGBshortAlpha(rgba: String)
      case RGB(rgb: String)
      case RGBA(rgba: String)
      
      init?(from hex: String) {
        var hexString = hex
        hexString.removeHashIfNecessary()
        
        guard let t = Type.transform(hex: hexString) else {
          return nil
        }
        self = t
      }
      
      static func transform(hex string: String) -> Type? {
        switch string.count {
        case 3: return .RGBshort(rgb: string)
        case 4: return .RGBshortAlpha(rgba: string)
        case 6: return .RGB(rgb: string)
        case 8: return .RGBA(rgba: string)
        default: return nil
        }
      }
      
      var value: String {
        switch self {
        case .RGBshort(let rgb):
          return rgb
        case .RGBshortAlpha(let rgba):
          return rgba
        case .RGB(let rgb):
          return rgb
        case .RGBA(let rgba):
          return rgba
        }
      }
        
      func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var hexValue: UInt32 = 0
        guard Scanner(string: value).scanHexInt32(&hexValue) else {
          return nil
        }
        
        let r, g, b, a, divisor: CGFloat
        switch self {
        case .RGBshort(_):
          divisor = 15
          r = CGFloat((hexValue & 0xF00) >> 8) / divisor
          g = CGFloat((hexValue & 0x0F0) >> 4) / divisor
          b = CGFloat( hexValue & 0x00F) / divisor
          a = 1
        case .RGBshortAlpha(_):
          divisor = 15
          r = CGFloat((hexValue & 0xF000) >> 12) / divisor
          g = CGFloat((hexValue & 0x0F00) >> 8) / divisor
          b = CGFloat((hexValue & 0x00F0) >> 4) / divisor
          a = CGFloat( hexValue & 0x000F) / divisor
        case .RGB(_):
          divisor = 255
          r = CGFloat((hexValue & 0xFF0000) >> 16) / divisor
          g = CGFloat((hexValue & 0x00FF00) >> 8) / divisor
          b = CGFloat( hexValue & 0x0000FF) / divisor
          a = 1
        case .RGBA(_):
          divisor = 255
          r = CGFloat((hexValue & 0xFF000000) >> 24) / divisor
          g = CGFloat((hexValue & 0x00FF0000) >> 16) / divisor
          b = CGFloat((hexValue & 0x0000FF00) >> 8) / divisor
          a = CGFloat( hexValue & 0x000000FF) / divisor
        }
        
        return (red: r, green: g, blue: b, alpha: a)
      }
    }
}
