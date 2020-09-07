//
//  MainPresenter.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

final class MainPresenter: MainPresenterProtocol {
    let userRepository: UserRepositoryProtocol
    let configRepository: ConfigRepositoryProtocol
    let userDefaultsHandler: UserDefaultsHandlerProtocol
    let view: MainTabBarControllerProtocol
    
    init(userRepository: UserRepositoryProtocol, configRepository: ConfigRepositoryProtocol, userDefaultsHandler: UserDefaultsHandlerProtocol, view: MainTabBarControllerProtocol) {
        self.userRepository = userRepository
        self.configRepository = configRepository
        self.userDefaultsHandler = userDefaultsHandler
        self.view = view
    }
    
    func getTintColor() -> UIColor? {
        return UIColor(userRepository.currentCompany?.primaryColor ?? "#6C99F2")
    }
    
    func getViewControllers() -> [UIViewController] {
        let attention = Router.shared.getTempoNavigationController(Router.shared.getAttention())
        attention.tabBarItem.title = Constants.Localizable.ATTENTION_TITLE
        attention.tabBarItem.image = #imageLiteral(resourceName: "tabAttention.png")
        
        let tips = Router.shared.getTempoNavigationController(Router.shared.getTips())
        tips.tabBarItem.title = Constants.Localizable.TIPS_TITLE
        tips.tabBarItem.image = #imageLiteral(resourceName: "tabTips.png")
        
        let triage = Router.shared.getTempoNavigationController(Router.shared.getTriage())
        triage.tabBarItem.title = Constants.Localizable.TRIAGE_TITLE
        triage.tabBarItem.image = #imageLiteral(resourceName: "tabTriage.png")
        
        return [
            triage,
            tips,
            attention
        ]
    }
    
    func validate() {
        shouldShowNewVersion { (isNewVersion) in
            guard isNewVersion else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.view.showNewVersionPopup()
                }
                return
            }
            
            self.configRepository.getHomeBanner(success: { (id, imageUrl, url) in
                guard id != self.userDefaultsHandler.integer(from: Constants.Keys.LAST_HOME_BANNER_ID) else {
                    return
                }
                self.userDefaultsHandler.save(value: id, to: Constants.Keys.LAST_HOME_BANNER_ID)
                self.view.showHomeBannerPopup(imageUrl, url)
            }) { (error) in
                self.view.show(.alert, message: error.localizedDescription)
            }
        }
    }
    
    private func shouldShowNewVersion(closure: ((Bool) -> Void)? = nil) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { (status, error) in
            guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, error == nil else {
                return
            }
            let lastAppVersionInAppStore = remoteConfig["ios_current_version"].stringValue ?? ""
            if appVersion.isVersion(lessThan: lastAppVersionInAppStore) {
                closure?(false)
            } else {
                closure?(true)
            }
        }
    }
}
