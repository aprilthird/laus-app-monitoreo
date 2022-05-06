//
//  TriajeOfflinePresenter.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 20/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
final class TriajeOfflinePresenter: TriajeOfflinePresenterProtocol {
    
    let opcSexo: [String] = ["Seleccione...", "Femenino", "Masculino"]
    var opcDepartamento: [String] = [String]()
    var opcProvincia: [Provincia] = [Provincia]()
    var opcDistrito: [Distrito] = [Distrito]()
    
    private let view: TriajeOfflineViewControllerProtocol
    
    init(view: TriajeOfflineViewControllerProtocol) {
        self.view = view
    }
    
    func loadOptions() {
        view.updateOpcSexo(options: opcSexo)
        loadUbigeo()
    }
    
    func keyboardDismiss() {
        print("hide keyboard")
    }
    
    func loadUbigeo() {
        print("PickerView: loadUbigeo")
        let utils = Utils()
        let jsonData = utils.readLocalJSONFile(forName: "Ubigeo")
        if let data = jsonData {
            if let obj = parse(jsonData: data){
                opcDepartamento = obj.Departamentos
                opcProvincia = obj.Provincias
                opcDistrito = obj.Distritos
                loadDepartamentos(items: opcDepartamento)
            }
        }
    }
    
    func loadDepartamentos(items: [String]){
        view.updateOpcsDepartmentos(options: items)
    }
    
    func loadProvincia(departamento: String){
        let filter = opcProvincia.filter{$0.Departamento == departamento}
        view.updateOpcProvincia(options: filter)
    }
    
    func loadDistritos(departamento: String, provincia: String){
        let filter = opcDistrito.filter{$0.Departamento == departamento && $0.Provincia == provincia}
        view.updateOpcDistrito(options: filter)
    }
    
    func parse(jsonData: Data) -> Ubigeo? {
        do {
            let decodedData = try JSONDecoder().decode(Ubigeo.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func validaEmail(email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[a-zA-Z0-9.!#$%&*+/=?^_{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?).*", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
}

struct Ubigeo: Codable {
    var Departamentos = [String]()
    var Provincias = [Provincia]()
    var Distritos = [Distrito]()
}

struct Provincia: Codable {
    var Departamento = ""
    var Provincia = ""
}

struct Distrito: Codable {
    var Departamento = ""
    var Provincia = ""
    var Distrito = ""
}
