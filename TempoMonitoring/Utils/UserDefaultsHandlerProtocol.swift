//
//  UserDefaultsHandlerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol UserDefaultsHandlerProtocol {
    func save(value: Any?, to key: String)
    func save<T: Codable>(_ value: T, to key: String) -> Bool
    func array(from key: String) -> [String]?
    func array<T>(of type: T, from key: String) -> [T]?
    func string(from key: String) -> String?
    func bool(from key: String) -> Bool
    func integer(from key: String) -> Int
    func custom<T: Codable>(of class: T.Type, from key: String) -> T?
    func remove(from key: String)
}
