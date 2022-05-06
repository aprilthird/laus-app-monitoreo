//
//  CompanySelectionPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Luis Jeffrey Rojas Montes on 17/04/22.
//  Copyright © 2022 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol CompanySelectionPresenterProtocol {
    func signIn(documentTypeId: Int, document: String, companyId: String)
}
