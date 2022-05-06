//
//  TriajeOfflineProtocol.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 20/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
protocol TriajeOfflinePresenterProtocol {
    func loadOptions()
    func keyboardDismiss()
    func loadUbigeo()
    func loadDepartamentos(items: [String])
    func loadProvincia(departamento: String)
    func loadDistritos(departamento: String, provincia: String)
    func validaEmail(email: String)-> Bool
}
