//
//  StringExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

extension String {
    // MARK: Source from: https://github.com/mRs-/HexColors/blob/master/Sources/HexColors.swift
    mutating func removeHashIfNecessary() {
      if hasPrefix("#") {
        self = replacingOccurrences(of: "#", with: "")
      }
    }
}
