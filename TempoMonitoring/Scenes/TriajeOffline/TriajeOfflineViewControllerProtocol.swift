//
//  TriajeOfflineViewControllerProtocol.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 20/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
protocol TriajeOfflineViewControllerProtocol {
    func updateOpcSexo(options: [String])
    func updateOpcsDepartmentos(options: [String])
    func updateOpcProvincia(options: [Provincia])
    func updateOpcDistrito(options: [Distrito])
    func configKeyboardAndPickers()
}
