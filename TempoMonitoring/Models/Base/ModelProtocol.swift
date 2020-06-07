//
//  ModelProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ModelProtocol: Codable {
    init(fromJSONObject jsonObject: JSON)
}
extension ModelProtocol {
    static func buildCollection(fromJSONArray jsonArray: [JSON]) -> [Self] {
        return jsonArray.map { (jsonObject) -> Self in
            Self(fromJSONObject: jsonObject)
        }
    }
}
