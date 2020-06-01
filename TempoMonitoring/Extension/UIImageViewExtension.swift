//
//  UIImageViewExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import AlamofireImage
import UIKit

extension UIImageView {
    func setImage(url: URL, placeholder: UIImage? = nil, transition: UIImageView.ImageTransition = .noTransition, completion: (() -> Void)? = nil) {
        af_setImage(withURL: url, placeholderImage: placeholder, filter: nil, progress: nil, progressQueue: .main, imageTransition: transition, runImageTransitionIfCached: false) { (response) in
            completion?()
        }
    }
    
    func setImage(url: URL, completion: @escaping() -> Void) {
        setImage(url: url, placeholder: nil, transition: .noTransition) {
            completion()
        }
    }
}
