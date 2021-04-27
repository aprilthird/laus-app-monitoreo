//
//  TimeZoneExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 27/04/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation

extension TimeZone {
    static var utc: TimeZone? {
        // MARK: UTC is equal to GMT
        return TimeZone(identifier: "GMT")
    }
}
