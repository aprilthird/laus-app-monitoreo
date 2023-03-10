//
//  Company.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import SwiftyJSON

class Company: ModelProtocol {
    var id: String
    var name: String
    var logoUrl: String
    var primaryColor: String
    var primaryDarkColor: String
    var accentColor: String
    var logoBackgroundColor: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoUrl
        case primaryColor
        case primaryDarkColor
        case accentColor
        case logoBackgroundColor
    }
    
    init() {
        id = ""
        name = ""
        logoUrl = ""
        primaryColor = ""
        primaryDarkColor = ""
        accentColor = ""
        logoBackgroundColor = ""
    }
    
    init(id: String, name: String, logoUrl: String, primaryColor: String, primaryDarkColor: String, accentColor: String, logoBackgroundColor: String) {
        self.id = id
        self.name = name
        self.logoUrl = logoUrl
        self.primaryColor = primaryColor
        self.primaryDarkColor = primaryDarkColor
        self.accentColor = accentColor
        self.logoBackgroundColor = logoBackgroundColor
    }
    
    required convenience init(fromJSONObject jsonObject: JSON) {
        self.init(id: jsonObject["id"].stringValue,
                  name: jsonObject["company_name"].stringValue,
                  logoUrl: jsonObject["logoUrl"].stringValue,
                  primaryColor: jsonObject["colorPrimary"].stringValue,
                  primaryDarkColor: jsonObject["colorPrimaryDark"].stringValue,
                  accentColor: jsonObject["colorAccent"].stringValue,
                  logoBackgroundColor: jsonObject["colorLogoBackground"].stringValue)
    }
}
