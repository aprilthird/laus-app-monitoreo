//
//  PasswordSignInPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Rosado on 11/1/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol PasswordSignInPresenterProtocol {
    func forgotPassword(documentTypeId: Int, document: String)
    func signIn(documentTypeId: Int, document: String, companyId: String, password: String)
}
