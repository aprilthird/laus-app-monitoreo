//
//  UserDefaultsHandler.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class UserDefaultsHandler: UserDefaultsHandlerProtocol {
    let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = .standard
    }
    
    init(suiteName: String) {
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Suite name is not correct")
        }
        self.userDefaults = userDefaults
    }
    
    func save(value: Any?, to key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func save<T>(_ value: T, to key: String) -> Bool where T : Decodable, T : Encodable {
        guard let data = try? JSONEncoder().encode(value) else { return false }
        userDefaults.set(data, forKey: key)
        return true
    }
    
    func string(from key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    func bool(from key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func integer(from key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    func custom<T>(of class: T.Type, from key: String) -> T? where T : Decodable, T : Encodable {
        guard let data = userDefaults.data(forKey: key),
            let custom = try? JSONDecoder().decode(T.self, from: data) as T else {
                return nil
        }
        return custom
    }
    
    func remove(from key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
