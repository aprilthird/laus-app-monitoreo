//
//  UserRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Keychain
import SwiftyJSON

final class UserRepository: UserRepositoryProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
    }
    
    var currentCompany: Company? {
        get {
            userDefaultsHandler.custom(of: Company.self, from: Constants.Keys.COMPANY)
        }
        
        set {
            guard let newValue = newValue else {
                userDefaultsHandler.remove(from: Constants.Keys.COMPANY)
                return
            }
            _ = userDefaultsHandler.save(newValue, to: Constants.Keys.COMPANY)
        }
    }
    
    func saveUserInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "user_name": names,
            "user_last_name": lastNames,
            "user_company": company,
            "user_document_type": documentTypeId,
            "user_document_number": document,
            "user_phone": phone
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.SAVE_USER_INFORMATION,
                            parameters: parameters,
        success: { (response) in
            success(true)
        }) { (error) in
            failure(error)
        }
    }
    
    func signIn(documentTypeId: Int, document: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "id_type": documentTypeId,
            "id_number": document
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.SIGN_IN,
                            parameters: parameters,
        success: { (response) in
            let company = Company(fromJSONObject: response["company"])
            let token = response["user"]["general_token"].stringValue
            let companyToken = response["user"]["company_token"].stringValue
            let isScannerEnabled = response["user"]["scanner_enabled"].boolValue
            
            _ = Keychain.save(token, forKey: Constants.Keys.TOKEN)
            _ = Keychain.save(companyToken, forKey: Constants.Keys.COMPANY_TOKEN)
            self.userDefaultsHandler.save(value: isScannerEnabled, to: Constants.Keys.IS_SCANNER_ENABLED)
            self.currentCompany = company
            
            success(true)
        }) { (error) in
            failure(error)
        }
    }
}
