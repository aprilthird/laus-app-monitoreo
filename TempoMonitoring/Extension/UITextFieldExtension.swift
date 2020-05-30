//
//  UITextFieldExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldSize: String {
    case right
    case left
}

extension UITextField {
    func addImage(_ image: UIImage, to side: TextFieldSize, padding: CGFloat, margin: CGSize) {
        let iconWidth: CGFloat = image.size.width - padding
        let iconHeight: CGFloat = image.size.height - padding
        
        let imageView = UIImageView(frame: CGRect(x: margin.width,
                                                  y: margin.height,
                                                  width: iconWidth,
                                                  height: iconHeight))
        imageView.image = image
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: iconWidth + margin.width,
                                        height: iconHeight + margin.height))
        view.addSubview(imageView)
        switch side {
        case .right:
            self.rightView = view
            self.rightViewMode = .always
        case .left:
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    func addPadding(_ padding: CGFloat = 8, to side: TextFieldSize) {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: padding,
                                        height: self.bounds.height))
        view.backgroundColor = .clear
        switch side {
        case .right:
            self.rightView = view
            self.rightViewMode = .always
        case .left:
            self.leftView = view
            self.leftViewMode = .always
        }
    }
}
