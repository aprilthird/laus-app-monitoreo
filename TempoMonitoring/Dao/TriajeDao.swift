//
//  TriajeDao.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 2/09/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import RealmSwift

public class TriajeDao {
    private var   database:Realm
    static let   sharedInstance = TriajeDao()
    
    public init() {
        database = try! Realm()
    }
    func getDataFromDB() ->   Results<mTriajeInformacionPersonal> {
        let results: Results<mTriajeInformacionPersonal> =   database.objects(mTriajeInformacionPersonal.self)
        return results
    }
    
    func deleteFromDb(object: mTriajeInformacionPersonal)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func insert(triaje: mTriajeInformacionPersonal) {
        try! db.write {
            db.add(triaje, update: .all)
        }
    }
    
    func getPendientes() -> mTriajeInformacionPersonal? {
        let results: Results<mTriajeInformacionPersonal> = database.objects(mTriajeInformacionPersonal.self).filter("status = 'P'")
        return results.first
    }
    
    func updatePendientes(triaje: mTriajeInformacionPersonal) {
        let item = database.objects(mTriajeInformacionPersonal.self).filter("correoElectronico == %@ and status = 'P'", triaje.correoElectronico).first!
        try! db.write {
            item.status = "E"
            db.add(item, update: .all)
        }
    }
}
