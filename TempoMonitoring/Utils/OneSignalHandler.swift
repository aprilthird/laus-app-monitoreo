//
//  OneSignalHandler.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 6/15/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import OneSignal
import UIKit

class OneSignalHandler: OneSignalHandlerProtocol {
    let userDefaultsHandler: UserDefaultsHandler
    let userRepository: UserRepositoryProtocol
    
    init(userDefaultsHandler: UserDefaultsHandler, userRepository: UserRepositoryProtocol) {
        self.userDefaultsHandler = userDefaultsHandler
        self.userRepository = userRepository
    }
    
    func initialConfiguration(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Constants.Credentials.ONE_SIGNAL_APP_ID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            self.getAuthorizationStatus()
            
            guard accepted else {
                return
            }
            let status = OneSignal.getPermissionSubscriptionState()
            if let id = status?.subscriptionStatus.userId {
                self.userDefaultsHandler.save(value: id, to: Constants.Keys.ONE_SIGNAL_ID)
                
                let wasFirstOpen = self.userDefaultsHandler.bool(from: Constants.Keys.WAS_FIRST_OPEN)
                let isDeviceSaved = self.userDefaultsHandler.bool(from: Constants.Keys.IS_DEVICE_REGISTERED)
                
                guard wasFirstOpen, !isDeviceSaved else {
                    return
                }
                self.userRepository.registerDevice()
            }
        })
    }
    
    func getAuthorizationStatus(closure: @escaping (UNAuthorizationStatus) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (isAuthorized, error) in
            print("Notification authorization: \(isAuthorized)")
        }
        current.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.userDefaultsHandler.save(value: true, to: Constants.Keys.IS_NOTIFICATION_ENABLED)
            case .denied, .notDetermined:
                self.userDefaultsHandler.save(value: false, to: Constants.Keys.IS_NOTIFICATION_ENABLED)
            @unknown default:
                self.userDefaultsHandler.save(value: false, to: Constants.Keys.IS_NOTIFICATION_ENABLED)
            }
            
            closure(settings.authorizationStatus)
        }
    }
}
