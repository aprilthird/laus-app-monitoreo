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
    let configRepository: ConfigRepositoryProtocol
    var view: AttentionWebViewViewControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, view: AttentionWebViewViewControllerProtocol) {
        self.configRepository = configRepository
        self.view = view
    }
    
    func getRightNavigationItems() -> [UIBarButtonItem] {
        let size = CGSize(width: 25, height: 25)
        
        let moreButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "moreButton.png").resizeImage(targetSize: size), style: .plain, target: self, action: #selector(showMoreSection))
        
        return [
            moreButtonBar
        ]
    }
    
    @objc private func showMoreSection() {
        view.showMoreSection()
    }
    
    func showWebView() {
        view.startProgress()
        
        configRepository.getAttentionUrl(success: { (url) in
            self.view.endProgress()
            
            self.view.openUrl(url)
        }) { (error) in
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
