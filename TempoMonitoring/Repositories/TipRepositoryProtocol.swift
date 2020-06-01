//
//  TipRepositoryProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol TipRepositoryProtocol {
    func getTipCategories(success: @escaping([(imageUrl: String, name: String, url: String)]) -> Void, failure: @escaping(Error) -> Void)
}
