//
//  TipRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import SwiftyJSON

final class TipRepository: TipRepositoryProtocol {
    let keychainHandler: KeychainHandlerProtocol
    
    init(keychainHandler: KeychainHandlerProtocol) {
        self.keychainHandler = keychainHandler
    }
    
    func getTipCategories(success: @escaping ([(imageUrl: String, name: String, url: String)]) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_TIP_CATEGORIES,
                           parameters: parameters,
        success: { (response) in
            var array = [(String, String, String)]()
            response.arrayValue.forEach { (jsonObject) in
                let imageUrl = jsonObject["imageUrl"].stringValue
                let name = jsonObject["name"].stringValue
                let url = jsonObject["link"].stringValue
                array.append((imageUrl, name, url))
            }
            success(array)
        }) { (error) in
            failure(error)
        }
    }
}
