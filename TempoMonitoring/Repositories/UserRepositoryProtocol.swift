//
//  UserRepositoryProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol UserRepositoryProtocol {
    func saveUserInformation(names: String, lastNames: String, company: String, documentType: Int, document: String, phone: String, success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
}
