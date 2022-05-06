//
//  UserRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import FirebaseCrashlytics
import SwiftyJSON

final class UserRepository: UserRepositoryProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let keychainHandler: KeychainHandlerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, keychainHandler: KeychainHandlerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.keychainHandler = keychainHandler
    }
    
    var currentCompany: Company? {
        get {
            return userDefaultsHandler.custom(of: Company.self, from: Constants.Keys.COMPANY)
        }
        
        set {
            guard let newValue = newValue else {
                userDefaultsHandler.remove(from: Constants.Keys.COMPANY)
                return
            }
            _ = userDefaultsHandler.save(newValue, to: Constants.Keys.COMPANY)
        }
    }
    
    func recoverPassword(documentTypeId: Int, document: String, success: @escaping (String?, String) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "id_type": documentTypeId,
            "id_number": document
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.RECOVER_PASSWORD,
                            parameters: parameters,
        success: { (response) in
            let image = response["image"].string
            let message = response["message"].stringValue
            success(image, message)
        }) { (error) in
            failure(error)
        }
    }
    
    func registerDevice(success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
                Crashlytics.crashlytics().record(error: NSError(domain: "AppVersionException", code: 503, userInfo: nil))
                success(false)
                return
        }
        let device = UIDevice.current
        let oneSignalId = userDefaultsHandler.string(from: Constants.Keys.ONE_SIGNAL_ID) ?? ""
        let areNotificationsEnabled = userDefaultsHandler.bool(from: Constants.Keys.IS_NOTIFICATION_ENABLED)
        let parameters: [String: Any] = [
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? "",
            "version_name": appVersion,
            "version_code": appVersion,
            "version_build": appBuild,
            "device_os": device.systemName,
            "device_os_version": device.systemVersion,
            "device_model": device.model,
            "device_manufacturer": "Apple",
            "onesignal_id": oneSignalId,
            "notifications_enabled": areNotificationsEnabled ? 1 : 0
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.REGISTER_DEVICE,
                            parameters: parameters,
        success: { [weak self] (response) in
            guard let self = self else { return }
            
            self.userDefaultsHandler.save(value: true, to: Constants.Keys.IS_DEVICE_REGISTERED)
            success(true)
        }) { (error) in
            failure(error)
        }
    }
    
    func saveUserInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, description: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "user_name": names,
            "user_last_name": lastNames,
            "user_company": company,
            "user_document_type": documentTypeId,
            "user_document_number": document,
            "user_phone": phone,
            "user_description": description
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
    
    func signIn(documentTypeId: Int, document: String, companyId: String, password: String?, success: @escaping (Bool, Bool) -> Void, failure: @escaping (Error) -> Void) {
        var parameters: [String: Any] = [
            "id_type": documentTypeId,
            "id_number": document,
            "compania_id": companyId
        ]
        var url = Constants.Service.NEW_SIGN_IN
        if let password = password {
            parameters["password"] = password
            url += "&with_password=true"
        }
        
        ResponseHelper.POST(with: .url,
                            url: url,
                            parameters: parameters,
        success: { [weak self] (response) in
            guard let self = self else { return }
            
            let isPasswordRequired = response["require_password"].boolValue
            let company = Company(fromJSONObject: response["company"])
            let token = response["user"]["general_token"].stringValue
            let companyToken = response["user"]["company_token"].stringValue
            let username = response["user"]["name"].stringValue
            let isScannerEnabled = response["user"]["scanner_enabled"].boolValue
            let isContactTracingEnabled = response["company"]["show_contact_tracing"].boolValue
            let unique_triaje = response["user"]["unique_triaje"].boolValue
            
            guard !isPasswordRequired else {
                success(true, true)
                return
            }
            
            _ = self.keychainHandler.save(value: documentTypeId, to: Constants.Keys.DOCUMENT_TYPE_ID)
            _ = self.keychainHandler.save(value: document, to: Constants.Keys.DOCUMENT)
            _ = self.keychainHandler.save(value: password, to: Constants.Keys.PASSWORD)
            _ = self.keychainHandler.save(value: token, to: Constants.Keys.TOKEN)
            _ = self.keychainHandler.save(value: companyToken, to: Constants.Keys.COMPANY_TOKEN)
            _ = self.keychainHandler.save(value: companyId, to: Constants.Keys.COMPANY_ID)
            self.userDefaultsHandler.save(value: username, to: Constants.Keys.WELCOME_NAME)
            self.userDefaultsHandler.save(value: isScannerEnabled, to: Constants.Keys.IS_SCANNER_ENABLED)
            self.userDefaultsHandler.save(value: isContactTracingEnabled, to: Constants.Keys.IS_CONTACT_TRACING_ENABLED)
            self.userDefaultsHandler.save(value: unique_triaje, to: Constants.Keys.UNIQUE_TRIAJE)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.userDefaultsHandler.save(value: dateFormatter.string(from: Date()), to: Constants.Keys.LAST_TOKENS_UPDATE)
            self.currentCompany = company
            
            success(true, false)
        }) { (error) in
            failure(error)
        }
    }
    
    func unregisterDevice(success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "token": keychainHandler.string(from: Constants.Keys.TOKEN) ?? ""
        ]
        
        ResponseHelper.POST(with: .url,
                            url: Constants.Service.UNREGISTER_DEVICE,
                            parameters: parameters,
        success: { [weak self] (response) in
            guard let self = self else { return }
            
            self.userDefaultsHandler.save(value: false, to: Constants.Keys.IS_DEVICE_REGISTERED)
            success(true)
        }) { (error) in
            failure(error)
        }
    }
    
    func getUserCompanies(documentType: String, document: String, success: @escaping([(String, String)]) -> Void, failure: @escaping(Error) -> Void) {
        let parameters: [String: Any] = [
            "tipo_documento": documentType,
            "numero_documento": document
        ]
        
        ResponseHelper.RAW_GET(with: .url,
                           url: Constants.Service.GET_USER_COMPANIES,
                           parameters: parameters,
                           success: { (response) in
            let responseCode = response["status"].intValue
            print("Response: \(responseCode) - \(response)")
            if(responseCode != 200) {
                let errorMessage = response["body"]["error_mensaje"].string ?? Constants.Localizable.DEFAULT_ERROR_MESSAGE
                failure(NSError(domain: "TPMT", code: 420, userInfo: [
                    NSLocalizedDescriptionKey: errorMessage
                ]))
                return
            }
            let options = response["body"]["data"].arrayValue.compactMap { (jsonObject) -> (String, String)? in
                let companyId = jsonObject["compania_id"]["_id"].stringValue
                let companyName = jsonObject["compania_id"]["nombre"].stringValue
                return (companyId, companyName)
            }
            success(options)
        }) { (error) in
            failure(error)
        }
    }
}
