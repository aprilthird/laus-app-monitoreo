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
    
    func loadElements(ofSize size: CGFloat) {
        configRepository.getTriageElements(success: { [weak self] (title, imageUrl, description, subDescription, triageButtonText, qrCodeButtonText, lastTriage, evaluation, isScannerEnabled) in
            guard let self = self else { return }
            
            let buttonSize = CGSize(width: 25, height: 25)
            let qrButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "qrCodeIcon.png").resizeImage(targetSize: buttonSize), style: .plain, target: self, action: #selector(self.showQRCodeReader))
            let items = [
                qrButtonBar
            ]
            self.view.updateRightNavigationItems(isScannerEnabled ? items : [])
            
            let attributedString = self.loadLastTriage(lastTriage: lastTriage, evaluation: evaluation, size: size)
            self.view.updateViews(title, imageUrl, description, subDescription, triageButtonText, qrCodeButtonText, attributedString)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.updateRightNavigationItems([])
            self.view.updateViews("", nil, nil, nil, nil, nil, nil)
        }
    }
    
    @objc private func showQRCodeReader() {
        view.showQRCodeReader()
    }
    
    private func loadLastTriage(lastTriage: String?, evaluation: String?, size: CGFloat) -> NSAttributedString? {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.roboto(withType: .regular, ofSize: size)
        ]
        
        guard let lastTriage = lastTriage else {
            return nil
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: "\(Constants.Localizable.LAST_TRIAGE_COMPLETED): \(lastTriage)", attributes: attributes)
        guard let evaluation = evaluation, !evaluation.isEmpty else {
            return mutableAttributedString
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

        return mutableAttributedString
    }
    
    func showQRCodeWebView() {
        view.startProgress()
        
        configRepository.getQRCodeUrl(success: { [weak self] (url) in
            guard let self = self else { return }
            
            self.view.showWebView(Constants.Localizable.QR_CODE_TITLE, url)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
    
    func showTriageWebView() {
        view.startProgress()
        
        configRepository.getTriageUrl(success: { [weak self] (url) in
            guard let self = self else { return }
            
            self.view.showWebView(Constants.Localizable.TRIAGE_TITLE, url)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
