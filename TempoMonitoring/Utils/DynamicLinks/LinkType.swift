//
//  LinkType.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 7/20/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

enum LinkType {
    case attention
    case notes(DetailEnum)
    case triage
}

enum DetailEnum {
    case list
    case detail(id: String)
}
