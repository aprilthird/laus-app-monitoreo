//
//  TipsPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class TipsPresenter: TipsPresenterProtocol {
    var tipRepository: TipRepositoryProtocol
    var userRepository: UserRepositoryProtocol
    var view: TipsCollectionViewControllerProtocol
    
    init(tipRepository: TipRepositoryProtocol, userRepository: UserRepositoryProtocol, view: TipsCollectionViewControllerProtocol) {
        self.tipRepository = tipRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func didSelect(tip: (imageUrl: String, name: String, url: String)) {
        view.openWebView(tip.url)
    }
    
    func getHeaderOptions() -> (backgroundColor: String, imageUrl: String, imageColor: String?)? {
        guard let company = userRepository.currentCompany else {
            return nil
        }
        return (company.primaryColor, company.logoUrl, company.logoBackgroundColor)
    }
    
    func loadTips() {
        view.startProgress()
        
        tipRepository.getTipCategories(success: { [weak self] (tips) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.updateTips(tips)
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.view.endProgress()
            
            self.view.show(.alert, message: error.localizedDescription)
        }
    }
}
