//
//  TriajeDinamicoPresenterProtocol.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 13/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
protocol TriajeDinamicoProtocol {
    func loadModel() -> mCuestionarioModel
    func initializeSections() -> respuestasDTO
    func saveModel(section: respuestasDTO)
}
