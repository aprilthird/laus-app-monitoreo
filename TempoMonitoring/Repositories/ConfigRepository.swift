//
//  ConfigRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
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
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_ATTENTION_URL,
                           parameters: parameters,
        success: { (response) in
            let token = self.keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
            success("\(response["url"].stringValue)\(token)")
        }) { (error) in
            failure(error)
        }
    }
    
    func getDocumentType(closure: @escaping ([DocumentType]) -> Void) {
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_DOCUMENT_TYPE,
                           parameters: nil,
        success: { (response) in
            let documentTypes = DocumentType.buildCollection(fromJSONArray: response["document_type"].arrayValue)
            _ = self.userDefaultsHandler.save(documentTypes, to: Constants.Keys.DOCUMENT_TYPES)
            closure(documentTypes)
        }) { (error) in
            let documentTypes = [DocumentType]()
            _ = self.userDefaultsHandler.save(documentTypes, to: Constants.Keys.DOCUMENT_TYPES)
            closure(documentTypes)
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
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
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
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_QR_CODE_URL,
                           parameters: parameters,
        success: { (response) in
            let token = self.keychainHandler.string(from: Constants.Keys.COMPANY_TOKEN) ?? ""
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
    
    func getTriageElements(success: @escaping (String, String, String, String, String?, String?, String?, String?) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_TRIAGE_ELEMENTS,
                           parameters: parameters,
        success: { (response) in
            let elements = response["elements"]
            
            let title = elements["title"].stringValue
            let image = elements["image"].stringValue
            let description = elements["description"].stringValue
            let subDescription = elements["sub_description"].stringValue
            let triageButtonText = elements["button_triaje_text"].string
            let qrCodeButtonText = elements["button_qr_text"].string
            let shouldShowLastTriage = elements["show_last_triaje"].boolValue
            let evaluation = elements["evaluation"].string
            var lastTriage: String? = nil
            if let last = elements["last_triaje"].string, !last.isEmpty && shouldShowLastTriage {
                lastTriage = last
            }
            
            success(title, image, description, subDescription, triageButtonText, qrCodeButtonText, lastTriage, evaluation)
        }) { (error) in
            failure(error)
        }
    }
    
    func getTriageUrl(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        let companyToken = keychainHandler.string(from: Constants.Keys.COMPANY_TOKEN) ?? ""
        let parameters: [String: Any] = [
            "token": companyToken
        ]
        
        ResponseHelper.GET(with: .url,
                           url: Constants.Service.GET_TRIAGE_URL,
                           parameters: parameters,
        success: { (response) in
            success("\(response["url"].stringValue)\(companyToken)")
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
    
    func saveDeviceIdentifier(success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        guard let deviceId = UIDevice.current.identifierForVendor else {
            failure(NSError(domain: "TPMT", code: 420, userInfo: ["message": "Device ID not found"]))
            return
        }
        guard let companyToken = keychainHandler.string(from: Constants.Keys.COMPANY_TOKEN) else {
            failure(NSError(domain: "TPMT", code: 420, userInfo: ["message": "Company Token not found"]))
            return
        }
        
        let parameters: [String: Any] = [
            "id_device": deviceId.uuidString,
            "token_compania": companyToken
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.SAVE_DEVICE_ID,
                            parameters: parameters,
        success: { (response) in
            success(true)
        }) { (error) in
            failure(error)
        }
    }
}
