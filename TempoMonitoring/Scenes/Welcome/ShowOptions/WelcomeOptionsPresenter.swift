//
//  WelcomeOptionsPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit
import NotificationBannerSwift

public protocol BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor
}

class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        let color = UIColor(named: "BackgroundNotification") ?? UIColor.black.withAlphaComponent(0.7)
        switch style {
            case .danger:
                return color
            case .info:
                return color
            case .customView:
                return color
            case .success:
                return color
            case .warning:
                return color
        }
    }

}


final class WelcomeOptionsPresenter: WelcomeOptionsPresenterProtocol, NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        print("notificationBannerWillAppear")
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        print("notificationBannerDidAppear")
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        print("notificationBannerWillDisappear")
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        print("notificationBannerDidDisappear")
    }
    
    
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
    
    func getBackgroundColor() -> String? {
        let color = userRepository.currentCompany?.primaryColor
        //NetworkStatus.shared.isOn ? userRepository.currentCompany?.primaryColor : "#293080"
        return color
    }
    
    func getRightNavigationItems() -> [UIBarButtonItem] {
        let buttonSize = CGSize(width: 25, height: 25)
        let qrButtonBar = UIBarButtonItem(image: #imageLiteral(resourceName: "qrCodeIcon.png").resizeImage(targetSize: buttonSize), style: .plain, target: self, action: #selector(showQRCodeReader))
        let isScannerEnabled = userDefaultsHandler.bool(from: Constants.Keys.IS_SCANNER_ENABLED)
        return (isScannerEnabled) ? [
            qrButtonBar
        ] : []
    }
    
    @objc private func showQRCodeReader() {
        view.showQRCodeReader()
    }
    
    func loadOptions() {
        if NetworkStatus.shared.isOn {
            view.startProgress()
            configRepository.getHomeButtons { [weak self] (options) in
                guard let self = self else { return }
                self.view.endProgress()
                self.view.updateOptions(options)
            } failure: { [weak self] (error) in
                self?.view.endProgress()
                self?.showOptionsOffline()
            }
        } else {
            showOptionsOffline()
        }
    }
    
    func showOptionsOffline(){
        let options = [("TRIAJE","https://d1cvnrbcr77880.cloudfront.net/images/tempo-covid/icons/triaje-icon.png", "")]
        self.view.updateOptions(options)
    }

    func downloadTriaje() {
        let repository = TriajeRepository()
        let token = configRepository.getToken()
        repository.getTriaje(token: token) { response in
            switch (response) {
            case .success(let dto):
                repository.saveLocalTriaje(dto: dto)
            case .failure(let error):
                print("Response: No se guardó. \(error)")
            }
        }
    }
    
    func getUniqueTriaje() -> Bool {
        return userDefaultsHandler.bool(from: Constants.Keys.UNIQUE_TRIAJE)
    }
    
    func sendEncuestaInicial() {
        let repository = TriajeRepository()
        let token = configRepository.getToken()
        
        let respuestasDao = RespuestasDao()
        let pendientes = respuestasDao.getPendientes()
        
        for encuestas in pendientes {
            let respuestasDto = encuestas.parsetoDTO()
            let tipo = tipoCuestionario(rawValue: encuestas.tipoEncuesta) ?? .diario
            repository.sendTriaje(tipo: tipo, token: token, triaje: respuestasDto) { response in
                var tipoStr = ""
                switch tipo {
                case .diario:
                    tipoStr = "diario"
                case .inicial:
                    tipoStr = "único"
                default:
                    print("")
                }
                
                let index = encuestas.id.index(encuestas.id.startIndex, offsetBy: 8)
                let fechaStr = encuestas.id[..<index]
                let prettyDate = Utils().stringToPrettyDate(input: String(fechaStr), format: "yyyyMMdd")
                switch (response) {
                case .success(let dto):
                    if dto.success {
                        DispatchQueue.main.async {
                            respuestasDao.updatePendientePorTipoEncuesta(triaje: encuestas)
                        }
                        
                        let banner1 = FloatingNotificationBanner(
                            title: "Laus",
                            subtitle: "Se envió la información de tu triaje \(tipoStr) con éxito (\(prettyDate)).",
                            style: .success
                        )
                        banner1.delegate = self
                        banner1.backgroundColor = UIColor(named: "BackgroundNotification")
                        banner1.show(
                            bannerPosition: .top,
                            queue: .default,
                            cornerRadius: 8,
                            shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                            shadowBlurRadius: 16,
                            shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
                        )
                    }
                case .failure(let error):
                    let banner1 = FloatingNotificationBanner(
                        title: "Laus",
                        subtitle: "No se envió la información de tu triaje \(tipoStr) correctamente (\(prettyDate)).",
                        style: .danger
                    )
                    banner1.delegate = self
                    banner1.show(
                        bannerPosition: .top,
                        queue: .default,
                        cornerRadius: 8,
                        shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                        shadowBlurRadius: 16,
                        shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
                    )
                }
            }
        }
    }
    
    func sendTriajeInfo(){
        let repository = TriajeRepository()
        let token = configRepository.getToken()
        
        let triajeDao = TriajeDao()
        let pendiente = triajeDao.getPendientes()
        
        let respuestasDto = pendiente?.parseDTO()
        
        if let triajePersonal = respuestasDto {
            repository.sendDataPersonal(token: token, triaje: triajePersonal) { response in
                switch (response) {
                case .success(let dto):
                    if dto.success {
                        DispatchQueue.main.async {
                            triajeDao.updatePendientes(triaje: pendiente!)
                        }
                    }
                case .failure(let error):
                    print("Error al enviar sendTriajeInfo: \(error)")
                }
            }
        }
    }
    
}
