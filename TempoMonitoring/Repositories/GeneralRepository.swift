//
//  GeneralRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class GeneralRepository: GeneralRepositoryProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
    }
    
    func saveLastVersionInAppStore(closure: @escaping() -> Void) {
        guard let identifier = Bundle.main.bundleIdentifier else {
            fatalError()
        }
        
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(identifier)")
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    print("AFError: \(error.localizedDescription)")
                    closure()
                case .success(let value):
                    let jsonObject = JSON(value)
                    print("Response: \(response.response?.statusCode ?? 0) - \(jsonObject)")
                    guard let results = jsonObject["results"].array, !results.isEmpty,
                        let version = results[0]["version"].string else {
                            closure()
                            return
                    }
                    self.userDefaultsHandler.save(value: version, to: Constants.Keys.LAST_APP_VERSION)
                    closure()
                }
        }
    }
}
