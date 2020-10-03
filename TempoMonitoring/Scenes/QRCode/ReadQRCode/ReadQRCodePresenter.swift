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
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("QRContent: \(string ?? "undefined")")
        
        guard let data = string?.data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                view.showQRCodeStatus(nil, nil, nil, nil)
                return true
        }
        let access = jsonObject["autorizacion_ingreso"] as? Bool
        let name = jsonObject["nombre_colaborador"] as? String
        let date = jsonObject["fecha_autorizacion"] as? String
        let description = jsonObject["texto"] as? String
        view.showQRCodeStatus(access, name, date, description)
        
        return true
    }
}
