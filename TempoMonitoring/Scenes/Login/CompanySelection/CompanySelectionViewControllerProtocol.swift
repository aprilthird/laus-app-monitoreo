//
//  CompanySelectionViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Luis Jeffrey Rojas Montes on 17/04/22.
//  Copyright © 2022 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol CompanySelectionViewControllerProtocol: AlertHandlerProtocol, HUDHandlerProtocol {
    func goToPasswordSignIn(_ documentTypeId: Int, _ document: String, _ companyId: String)
    func goToMain()
}
