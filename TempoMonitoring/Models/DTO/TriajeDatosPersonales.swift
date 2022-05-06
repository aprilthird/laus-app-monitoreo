//
//  TriajeDatosPersonales.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 30/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
// MARK: - TriajeDatosPersonales
struct TriajeDatosPersonales: Codable {
    let datosPersonales: DatosPersonales
    let datosContactoFamiliar: DatosContactoFamiliar

    enum CodingKeys: String, CodingKey {
        case datosPersonales = "datos_personales"
        case datosContactoFamiliar = "datos_contacto_familiar"
    }
}

// MARK: - DatosContactoFamiliar
struct DatosContactoFamiliar: Codable {
    let nombres, telefono: String
}

// MARK: - DatosPersonales
struct DatosPersonales: Codable {
    let nombres, apellidoPaterno, apellidoMaterno, sexo: String
    let departamento, provincia, distrito, direccion: String
    let telefono, correoElectronico: String

    enum CodingKeys: String, CodingKey {
        case nombres
        case apellidoPaterno = "apellido_paterno"
        case apellidoMaterno = "apellido_materno"
        case sexo, departamento, provincia, distrito, direccion, telefono
        case correoElectronico = "correo_electronico"
    }
}
