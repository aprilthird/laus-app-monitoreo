//
//  TipsPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

protocol TipsPresenterProtocol {
    func didSelect(tip: (imageUrl: String, name: String, url: String))
    func getHeaderOptions() -> (backgroundColor: String, imageUrl: String, imageColor: String?)?
    func loadTips()
}
