//
//  WelcomeOptionsPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

final class WelcomeOptionsPresenter: WelcomeOptionsPresenterProtocol {
    private let userDefaultsHandler: UserDefaultsHandlerProtocol
    private let configRepository: ConfigRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let view: WelcomeOptionsViewControllerProtocol
    
    init(userDefaultsHandler: UserDefaultsHandlerProtocol, configRepository: ConfigRepositoryProtocol, userRepository: UserRepositoryProtocol, view: WelcomeOptionsViewControllerProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.configRepository = configRepository
        self.userRepository = userRepository
        self.view = view
    }
    
    func getHeaderOptions() -> (String, String) {
        let welcomeName = userDefaultsHandler.string(from: Constants.Keys.WELCOME_NAME) ?? ""
        let companyName = userRepository.currentCompany?.name ?? ""
        let title = (!welcomeName.isEmpty) ? "¡Hola \(welcomeName)!" : "¡Hola!"
        let subtitle = "Bienvenid@ a tu app digital de Seguridad y Salud\((!companyName.isEmpty) ? " en \(companyName)" : "").\n¿Qué acción te gustaría realizar hoy?"
        return (title, subtitle)
    }
    
    func getPrimaryColor() -> String? {
        return userRepository.currentCompany?.primaryColor
    }
    
    func loadOptions() {
        view.startProgress()
        
        configRepository.getHomeButtons { [weak self] (options) in
            guard let self = self else { return }
            self.view.endProgress()
            self.view.updateOptions(options)
        } failure: { [weak self] (error) in
            self?.view.endProgress()
            self?.view.show(.alert, message: error.localizedDescription)
        }

    }
}
