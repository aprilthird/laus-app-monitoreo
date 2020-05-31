//
//  SplashPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class SplashPresenter: SplashPresenterProtocol {
    let view: SplashViewControllerProtocol
    
    init(view: SplashViewControllerProtocol) {
        self.view = view
    }
    
    func startAnimation() {
        view.goToFirstScene()
    }
}
