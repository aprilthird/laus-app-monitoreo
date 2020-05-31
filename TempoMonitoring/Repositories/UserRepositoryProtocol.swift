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
    
    func saveUserInformation(names: String, lastNames: String, company: String, documentTypeId: Int, document: String, phone: String, success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
    func signIn(documentTypeId: Int, document: String, success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
}
