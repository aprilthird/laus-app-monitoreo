//
//  RespuestasDao.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 13/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

public class RespuestasDao {
    private var database: Realm
    static let sharedInstance = RespuestasDao()
    
    public init() {
        database = try! Realm()
    }
    
    func getDataFromDB() -> Results<mRespuestas> {
        let results: Results<mRespuestas> =   database.objects(mRespuestas.self)
        return results
    }
    
    func deleteAll()   {
        let allObjects = database.objects(mRespuestas.self)
        try! database.write {
            database.delete(allObjects)
        }
    }
    
    func insert(triaje: mRespuestas) {
        try! db.write {
            db.add(triaje, update: .all)
        }
    }
    
    func getPendientes() ->  Results<mRespuestas> {
        let results: Results<mRespuestas> = database.objects(mRespuestas.self).filter("status = 'P'").sorted(byKeyPath: "fechaCreacion", ascending: true)
        return results
    }
    
    func getExisteDiario() ->  Bool {
        let fechaActual = Utils().DateToString(fecha: Date(), format: "yyyyMMdd")
        let results: Results<mRespuestas> = database.objects(mRespuestas.self).filter("tipoEncuesta = %@ and id beginsWith %@", tipoCuestionario.diario.rawValue, fechaActual)
        let rpta = results.count > 0
        
        return rpta
    }
    
    func updatePendientePorTipoEncuesta(triaje: mRespuestas) {
        let item = database.objects(mRespuestas.self).filter("id == %@ and status = 'P'", triaje.id).first!
        try! db.write {
            item.status = "E"
            db.add(item, update: .all)
        }
    }
    
    func triajeUnicoCompleto() -> Bool{
        let results: Results<mRespuestas> = database.objects(mRespuestas.self).filter("tipoEncuesta = %@", "inicial")
        return results.count > 0
    }
    
}
