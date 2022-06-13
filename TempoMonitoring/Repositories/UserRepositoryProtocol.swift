//
//  UserRepositoryProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol UserRepositoryProtocol {
    var currentCompany: Company? { get set }
    
    func recoverPassword(documentTypeId: Int, document: String, companyId: String, success: @escaping(String?, String) -> Void, failure: @escaping(Error) -> Void)
    func registerDevice(success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
    func saveUserInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, description: String, success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
    func signIn(documentTypeId: Int, document: String, companyId: String, password: String?, success: @escaping(Bool, Bool) -> Void, failure: @escaping(Error) -> Void)
    func unregisterDevice(success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
    func getUserCompanies(documentType: String, document: String, success: @escaping([(String, String)]) -> Void, failure: @escaping(Error) -> Void)
}
extension UserRepositoryProtocol {
    func registerDevice() {
        registerDevice(success: { (_) in
        }) { (_) in
        }
    }
    
    func unregisterDevice() {
        unregisterDevice(success: { (_) in
        }) { (_) in
        }
    }
}
