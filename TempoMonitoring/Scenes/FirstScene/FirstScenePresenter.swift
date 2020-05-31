//
//  FirstScenePresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

final class FirstScenePresenter: FirstScenePresenterProtocol {
    private let configRepository: ConfigRepositoryProtocol
    private let view: FirstSceneVieControllerProtocol
    
    init(configRepository: ConfigRepositoryProtocol, view: FirstSceneVieControllerProtocol) {
        self.configRepository = configRepository
        self.view = view
    }
    
    func didLoadSignUpLogic() {
        configRepository.getSignUpUrl(success: { (url, visibility) in
            self.view.updateView(url: url, visibility: visibility)
        }) { (error) in
        }
    }
}
