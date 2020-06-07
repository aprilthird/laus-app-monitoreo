//
//  DocumentType.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 6/5/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import SwiftyJSON

class DocumentType: ModelProtocol {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init() {
        id = 0
        name = ""
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required convenience init(fromJSONObject jsonObject: JSON) {
        self.init(id: jsonObject["id"].intValue,
                  name: jsonObject["name"].stringValue)
    }
}
