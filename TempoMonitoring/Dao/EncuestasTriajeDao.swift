//
//  EncuestasTriajeDao.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 30/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

public class EncuestasTriajeDao {
    private var database:Realm
    static let sharedInstance = EncuestasTriajeDao()
    
    public init() {
        database = try! Realm()
    }
    func getDataFromDB() -> Results<mEncuestasTriaje> {
        let results: Results<mEncuestasTriaje> =   database.objects(mEncuestasTriaje.self)
        return results
    }
    
    func deleteAll()   {
        let allObjects = database.objects(mEncuestasTriaje.self)
        try! database.write {
            database.delete(allObjects)
        }
    }
    
    func insert(triaje: mEncuestasTriaje) {
        try! db.write {
            db.add(triaje, update: .all)
        }
    }
    
    func setEnviadoCuestionarioInicial(estado: Bool) {
        try! db.write {
            let data = self.getDataFromDB()
            if data.count == 0 {
                return
            }
            data[0].payload?.cuestionario?.cuestionarioInicial!.enviado = estado
        }
    }
    
    func getEnviadoCuestionarioInicial() -> Bool {
        try! db.write {
            let data = self.getDataFromDB()
            if data.count == 0 {
                return false
            }
            if let inicial = data[0].payload?.cuestionario?.cuestionarioInicial {
                return inicial.enviado
            }
            return false
        }
    }
}
