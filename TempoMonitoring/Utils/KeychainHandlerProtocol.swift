//
//  KeychainHandlerProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol KeychainHandlerProtocol {
    func bool(from key: String) -> Bool
    func custom<T: Codable>(of class: T.Type, from key: String) -> T?
    func data(from key: String) -> Data?
    func double(from key: String) -> Double
    func float(from key: String) -> Float
    func integer(from key: String) -> Int
    func string(from key: String) -> String?
    func save(_ value: Any?, to key: String)
    func save<T: Codable>(_ value: T, to key: String) -> Bool
    func remove(from key: String)
    func remove(from key: String) -> Bool
}
