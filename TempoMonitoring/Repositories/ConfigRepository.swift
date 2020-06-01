//
//  ConfigRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Keychain
import SwiftyJSON

final class ConfigRepository: ConfigRepositoryProtocol {
    let keychainHandler: KeychainHandlerProtocol
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    
    init(keychainHandler: KeychainHandlerProtocol, userDefaultsHandler: UserDefaultsHandlerProtocol) {
        self.keychainHandler = keychainHandler
        self.userDefaultsHandler = userDefaultsHandler
    }
    
    func getAttentionUrl(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": Keychain.load(Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_ATTENTION_URL,
                           parameters: parameters,
        success: { (response) in
            let token = Keychain.load(Constants.Keys.COMPANY_TOKEN) ?? ""
            success("\(response["url"].stringValue)\(token)")
        }) { (error) in
            failure(error)
        }
    }
    
    func getFAQs(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_FAQS,
                           parameters: nil,
        success: { (response) in
            success(response["url"].stringValue)
        }) { (error) in
            failure(error)
        }
    }
    
    func getHomeBanner(success: @escaping (Int, String, String) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": Keychain.load(Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_HOME_BANNER,
                           parameters: parameters,
       success: { (response) in
            success(response["id"].intValue,
                    response["imageUrl"].stringValue,
                    response["redirectUrl"].stringValue)
        }) { (error) in
            failure(error)
        }
    }
    
    func getQRCodeUrl(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": Keychain.load(Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_QR_CODE_URL,
                           parameters: parameters,
        success: { (response) in
            let token = Keychain.load(Constants.Keys.COMPANY_TOKEN) ?? ""
            success("\(response["url"].stringValue)\(token)")
        }) { (error) in
            failure(error)
        }
    }
    
    func getSignUpUrl(success: @escaping (String, Bool) -> Void, failure: @escaping (Error) -> Void) {
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_SIGN_UP_URL,
                           parameters: nil,
        success: { (response) in
            success(response["url"].stringValue, response["visibility"].bool ?? false)
        }) { (error) in
            failure(error)
        }
    }
    
    func getTriageUrl(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": Keychain.load(Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_TRIAGE_URL,
                           parameters: parameters,
        success: { (response) in
            let token = Keychain.load(Constants.Keys.COMPANY_TOKEN) ?? ""
            success("\(response["url"].stringValue)\(token)")
        }) { (error) in
            failure(error)
        }
    }
    
    func getTutorial(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_TUTORIAL,
                           parameters: nil,
        success: { (response) in
            success(response["url"].stringValue)
        }) { (error) in
            failure(error)
        }
    }
}
