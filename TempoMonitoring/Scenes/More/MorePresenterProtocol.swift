//
//  MorePresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol MorePresenterProtocol {
    func didSelect(option: (image: UIImage, type: MoreOptionType, title: String))
    func getBackgroundColor() -> UIColor?
    func getImageOptions() -> (imageUrl: String, color: String?)?
    func loadOptions() -> [(image: UIImage, type: MoreOptionType, title: String)]
}
