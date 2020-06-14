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
    
    func loadLastTriage(ofSize size: CGFloat) -> String {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.roboto(withType: .regular, ofSize: size)
        ]
        
        configRepository.getLastTriage(success: { (lastTriage, evaluation) in
            let mutableAttributedString = NSMutableAttributedString(string: "\(Constants.Localizable.LAST_TRIAGE_COMPLETED): \(lastTriage)", attributes: attributes)
            
            guard let evaluation = evaluation, !evaluation.isEmpty else {
                self.view.updateLastTriage(false, mutableAttributedString)
                return
            }
            let firstBracket = NSAttributedString(string: " (", attributes: attributes)
            let secondBracket = NSAttributedString(string: ")", attributes: attributes)
            if evaluation.lowercased().contains("no apto") {
                attributes[.foregroundColor] = UIColor("#FF0000")
            } else if evaluation.lowercased().contains("apto") {
                attributes[.foregroundColor] = UIColor("#00AB07")
            }
            let evaluationAttributedString = NSAttributedString(string: evaluation, attributes: attributes)
            mutableAttributedString.append(firstBracket)
            mutableAttributedString.append(evaluationAttributedString)
            mutableAttributedString.append(secondBracket)
            
            self.view.updateLastTriage(false, mutableAttributedString)
        }) { (error) in
            self.view.updateLastTriage(false, NSAttributedString(string: Constants.Localizable.NO_LAST_TRIAGE, attributes: attributes))
        }
        
        return Constants.Localizable.LOADING
    }
    
    func showQRCodeWebView() {
        view.startProgress()
        
        configRepository.getQRCodeUrl(success: { (url) in
            self.view.showWebView(Constants.Localizable.QR_CODE_TITLE, url)
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
