//
//  GeneralRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
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
        
        ResponseHelper.GET(with: .url,
                           url: "https://itunes.apple.com/lookup?bundleId=\(identifier)",
                           parameters: nil,
        success: { (response) in
            let version = response["results"].arrayValue[0]["version"].stringValue
            self.userDefaultsHandler.save(value: version, to: Constants.Keys.LAST_APP_VERSION)
            closure()
        }) { (error) in
            closure()
        }
    }
}
