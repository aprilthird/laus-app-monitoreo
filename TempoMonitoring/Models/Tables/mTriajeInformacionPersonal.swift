//
//  mTriajeInformacionPersonal.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 28/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

class mTriajeInformacionPersonal: Object {
    @objc dynamic var nombres = ""
    @objc dynamic var apellidoPaterno = ""
    @objc dynamic var apellidoMaterno = ""
    @objc dynamic var sexo = ""
    @objc dynamic var departamento = ""
    @objc dynamic var provincia = ""
    @objc dynamic var distrito = ""
    @objc dynamic var direccion = ""
    @objc dynamic var telefono = ""
    @objc dynamic var correoElectronico = ""
    @objc dynamic var familiarNombres = ""
    @objc dynamic var familiarTelefono = ""
    
    @objc dynamic var status = ""
    
    @objc open override class func primaryKey() -> String {
        return "correoElectronico"
    }
    
    convenience init(nombres: String, apellidoPaterno: String, apellidoMaterno: String, sexo: String, departamento: String, provincia: String, distrito: String, direccion: String, telefono: String, correoElectronico: String, familiarNombres: String, familiarTelefono: String, status: String) {
        self.init()
        self.nombres = nombres
        self.apellidoPaterno = apellidoPaterno
        self.apellidoMaterno = apellidoMaterno
        self.sexo = sexo
        self.departamento = departamento
        self.provincia = provincia
        self.distrito = distrito
        self.direccion = direccion
        self.telefono = telefono
        self.correoElectronico = correoElectronico
        self.familiarNombres = familiarNombres
        self.familiarTelefono = familiarTelefono
        self.status = status
    }
    
    func parseDTO() -> TriajeDatosPersonales {
        let datos_Personales = DatosPersonales(nombres: self.nombres,
                                               apellidoPaterno: self.apellidoPaterno,
                                               apellidoMaterno: self.apellidoMaterno,
                                               sexo: self.sexo,
                                               departamento: self.departamento,
                                               provincia: self.provincia,
                                               distrito: self.distrito,
                                               direccion: self.direccion,
                                               telefono: self.telefono,
                                               correoElectronico: self.correoElectronico)
        let datos_Contacto = DatosContactoFamiliar(nombres: self.familiarNombres, telefono: self.familiarTelefono)
        let triaje = TriajeDatosPersonales(datosPersonales: datos_Personales, datosContactoFamiliar: datos_Contacto)
        return triaje
    }
    
}
