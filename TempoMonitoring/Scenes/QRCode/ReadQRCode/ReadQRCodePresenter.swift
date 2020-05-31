//
//  ReadQRCodePresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ReadQRCodePresenter: ReadQRCodePresenterProtocol {
    let userRepository: UserRepositoryProtocol
    let view: ReadQRCodeViewControllerProtocol
    
    init(userRepository: UserRepositoryProtocol, view: ReadQRCodeViewControllerProtocol) {
        self.userRepository = userRepository
        self.view = view
    }
    
    func getCloseButtonBackgroundColor() -> UIColor? {
        guard let company = userRepository.currentCompany else { return nil }
        return UIColor(company.accentColor)
    }
    
    func isQRCodeValid(_ string: String?) -> Bool {
        guard let data = string?.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return false
        }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("QRContent: \(string ?? "undefined")")
        
        let status: QRCodeStatus = (jsonObject["status"] as? Int != nil) ? QRCodeStatus(rawValue: jsonObject["status"] as! Int) ?? .invalidCode : .invalidCode
        let name = jsonObject["name"] as? String
        let date = jsonObject["date"] as? String
        view.showQRCodeStatus(status, name, date)
        
        return true
    }
}
