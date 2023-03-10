//
//  ConfigRepositoryProtocol.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

protocol ConfigRepositoryProtocol {
    func getAttentionUrl(success: @escaping(String) -> Void, failure: @escaping(Error) -> Void)
    func getDocumentType(closure: @escaping([DocumentType]) -> Void)
    func getHomeBanner(success: @escaping(Int, String, String) -> Void, failure: @escaping(Error) -> Void)
    func getHomeButtons(success: @escaping([(String, String, String)]) -> Void, failure: @escaping(Error) -> Void)
    func getQRCodeUrl(success: @escaping(String) -> Void, failure: @escaping(Error) -> Void)
    func getResourceLinks(success: @escaping(String, String, String, String) -> Void, failure: @escaping(Error) -> Void)
    func getSignUpUrl(success: @escaping(String, Bool) -> Void, failure: @escaping(Error) -> Void)
    func getTriageElements(success: @escaping (String, String, String, String, String?, String?, String?, String?, Bool) -> Void, failure: @escaping (Error) -> Void)
    func getTriageUrl(success: @escaping(String) -> Void, failure: @escaping(Error) -> Void)
    func saveDeviceIdentifier(success: @escaping(Bool) -> Void, failure: @escaping(Error) -> Void)
    func getToken()->String
}
extension ConfigRepositoryProtocol {
    func saveDeviceIdentifier() {
        saveDeviceIdentifier(success: { (_) in
        }) { (_) in
        }
    }
}
