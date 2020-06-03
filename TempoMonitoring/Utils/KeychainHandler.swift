//
//  KeychainHandler.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

import Foundation
import Security

final class KeychainHandler: KeychainHandlerProtocol {
    let suiteName: String
    
    init() {
        self.suiteName = Bundle.main.bundleIdentifier ?? ""
    }
    
    init(suiteName: String) {
        self.suiteName = suiteName
    }
    
    func bool(from key: String) -> Bool {
        guard let data = retrieveValue(fromKeychainWith: key),
            let number = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber else {
                return false
        }
        return number.boolValue
    }
    
    func custom<T>(of class: T.Type, from key: String) -> T? where T : Decodable, T : Encodable {
        guard let data = retrieveValue(fromKeychainWith: key) else {
                return nil
        }
        return try? JSONDecoder().decode(T.self, from: data) as T
    }
    
    func data(from key: String) -> Data? {
        return retrieveValue(fromKeychainWith: key)
    }
    
    func double(from key: String) -> Double {
        guard let data = retrieveValue(fromKeychainWith: key),
            let number = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber else {
                return 0.000
        }
        return number.doubleValue
    }
    
    func float(from key: String) -> Float {
        guard let data = retrieveValue(fromKeychainWith: key),
            let number = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber else {
                return 0.000
        }
        return number.floatValue
    }
    
    func integer(from key: String) -> Int {
        guard let data = retrieveValue(fromKeychainWith: key),
            let number = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber else {
                return 0
        }
        return number.intValue
    }
    
    func string(from key: String) -> String? {
        guard let data = retrieveValue(fromKeychainWith: key) else {
                return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func save(_ value: Any?, to key: String) {
        let data: Data?
        switch value.self {
        case is String:
            let string = value as? String
            data = string?.data(using: .utf8, allowLossyConversion: false)
        case is Int:
            let number = NSNumber(value: value as! Int)
            data = NSKeyedArchiver.archivedData(withRootObject: number)
        case is Double:
            let number = NSNumber(value: value as! Double)
            data = NSKeyedArchiver.archivedData(withRootObject: number)
        case is Float:
            let number = NSNumber(value: value as! Float)
            data = NSKeyedArchiver.archivedData(withRootObject: number)
        case is Bool:
            let number = NSNumber(value: value as! Bool)
            data = NSKeyedArchiver.archivedData(withRootObject: number)
        case is Data:
            data = value as? Data
        default:
            data = nil
        }
        guard let newData = data else {
            return
        }
        _ = saveValue(data: newData, toKeychainWith: key)
    }
    
    func save<T>(_ value: T, to key: String) -> Bool where T : Decodable, T : Encodable {
        guard let data = try? JSONEncoder().encode(value) else {
            return false
        }
        return saveValue(data: data, toKeychainWith: key)
    }
    
    func remove(from key: String) {
        _ = deleteValue(fromKeychainWith: key)
    }
    
    func remove(from key: String) -> Bool {
        return deleteValue(fromKeychainWith: key)
    }
    
    private func saveValue(data: Data, toKeychainWith key: String) -> Bool {
        let keychainQuery: NSMutableDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: suiteName,
            kSecAttrAccount: key
        ]
        
        var status = SecItemCopyMatching(keychainQuery as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            let attributes: NSMutableDictionary = [
                kSecValueData: data
            ]
            
            status = SecItemUpdate(keychainQuery as CFDictionary, attributes as CFDictionary)
            if status != errSecSuccess {
                fallthrough
            }
            return true
        case errSecItemNotFound:
            keychainQuery[kSecValueData] = data
            
            status = SecItemAdd(keychainQuery as CFDictionary, nil)
            if status != errSecSuccess {
                fallthrough
            }
            return true
        default:
            return false
        }
    }
    
    private func retrieveValue(fromKeychainWith key: String) -> Data? {
        let keychainQuery: NSMutableDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: suiteName,
            kSecAttrAccount: key,
            kSecReturnAttributes: kCFBooleanTrue!,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        guard status == errSecSuccess,
            let queriedItem = result as? NSMutableDictionary,
            let data = queriedItem[kSecValueData] as? Data else {
                return nil
        }
        return data
    }
    
    private func deleteValue(fromKeychainWith key: String) -> Bool {
        let keychainQuery: NSMutableDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: suiteName,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!
        ]
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        return (status != errSecSuccess) ? false : true
    }
}
