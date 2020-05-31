//
//  UserRepository.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    
    init() {
    }
    
    func saveUserInformation(names: String, lastNames: String, company: String, documentType: Int, document: String, phone: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "user_name": names,
            "user_last_name": lastNames,
            "user_company": company,
            "user_document_type": documentType,
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
}
