//
//  TriagePresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

final class TriagePresenter: TriagePresenterProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let configRepository: ConfigRepositoryProtocol
    let view: TriageViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, configRepository: ConfigRepositoryProtocol, view: TriageViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.configRepository = configRepository
        self.view = view
    }
    
    func showQRCodeWebView() {
        view.startProgress()
        
        configRepository.getQRCodeUrl(success: { (url) in
            self.view.showWebView(nil, url)
        }) { (error) in
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
    
    func getRightNavigationItems() -> [UIBarButtonItem] {
        let size = CGSize(width: 25, height: 25)
        
        guard UserDefaults.standard.bool(forKey: Constants.Keys.IS_SCANNER_ENABLED) else {
            return []
        }
        let qrButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "qrCodeIcon.png").resizeImage(targetSize: size), style: .plain, target: self, action: #selector(showQRCodeReader))
        return [
            qrButtonBar
        ]
    }
    
    @objc private func showQRCodeReader() {
        view.showQRCodeReader()
    }
    
    func showTriageWebView() {
        view.startProgress()
        
        configRepository.getTriageUrl(success: { (url) in
            self.view.showWebView(Constants.Localizable.TRIAGE_TITLE, url)
        }) { (error) in
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
