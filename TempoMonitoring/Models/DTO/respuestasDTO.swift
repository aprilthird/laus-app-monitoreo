//
//  respuestasDTO.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 13/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation

struct respuestasDTO: Codable {
    var id: String
    var tipoEncuesta: String
    var idEncuesta: String
    var secciones: [Secciones]

    enum CodingKeys: String, CodingKey {
        case id
        case tipoEncuesta
        case idEncuesta = "_id"
        case secciones = "secciones"
    }
    
    func getData() -> [String: Any] {
        var seccionesData = [[String: Any]]()
        for seccion in self.secciones {
            seccionesData.append(seccion.getData())
        }
        return [
            "_id": idEncuesta,
            "secciones": seccionesData
        ]
    }
    
}
