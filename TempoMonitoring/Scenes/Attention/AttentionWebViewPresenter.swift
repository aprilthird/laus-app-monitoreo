//
//  AttentionWebViewPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit

class AttentionWebViewPresenter: AttentionWebViewPresenterProtocol {
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let configRepository: ConfigRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    var view: AttentionWebViewViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, view: AttentionWebViewViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func getLeftNavigationItems(canGoBack: Bool) -> [UIBarButtonItem] {
        let size = CGSize(width: 25, height: 25)
        
        guard canGoBack else {
            return []
        }
        let backButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "backButton.png").resizeImage(targetSize: size), style: .plain, target: self, action: #selector(goBack))
        
        return [
            backButtonBar
        ]
    }
    
    @objc private func goBack() {
        view.goBack()
    }
    
    func getRightNavigationItems() -> [UIBarButtonItem] {
        let size = CGSize(width: 25, height: 25)
        
        let moreButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "moreButton.png").resizeImage(targetSize: size), style: .plain, target: self, action: #selector(showMoreSection))
        let contactTracingButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "tabTracing").resizeImage(targetSize: size), style: .plain, target: self, action: #selector(showContactTracing))
        
        var barButtons = [
            moreButtonBar
        ]
        if userDefaultsHandler.bool(from: Constants.Keys.IS_CONTACT_TRACING_ENABLED) {
            barButtons.append(contactTracingButtonBar)
        }
        
        return barButtons
    }
    
    @objc private func showMoreSection() {
        view.showMoreSection()
    }
    
    @objc private func showContactTracing() {
        view.showContactTracing()
    }
    
    func getTintColor() -> UIColor? {
        return UIColor(userRepository.currentCompany?.primaryColor ?? "#6C99F2")
    }
    
    func showWebView() {
        view.startProgress()
        
        configRepository.getAttentionUrl(success: { [weak self] (url) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.openUrl(url)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
