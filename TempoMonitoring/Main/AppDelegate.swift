//
//  AppDelegate.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
import dp3t_lib_ios
import Network
import RealmSwift

var db: Realm = try! Realm()

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

@available(iOS 12.0, *)
class NetworkStatus {
    static public let shared = NetworkStatus()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var isOn: Bool = true
    var connType: ConnectionType = .wifi

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { path in
            self.isOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
            print("NetworkStatus (\(self.connType)): \(self.isOn)")
        }
    }

    func stop() {
        self.monitor.cancel()
    }

    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .unknown
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Keyboard
        IQKeyboardManager.shared.enable = true

        // Onesignal
        Router.shared.oneSignalHandler.initialConfiguration(launchOptions)
        
        // Firebase
        FirebaseApp.configure()
        
        //Realm
        configRealm()
        
        //CheckStatus
        if #available(iOS 12.0, *) {
            NetworkStatus.shared.start()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = Router.shared.getSplash()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        AmigoContactTracing.shared.setLaunchOptions(launchOptions)
        
        return true
    }
    
    func configRealm(){
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock : { migration, oldSchemaVersion in
                switch oldSchemaVersion {
                case 2:
                    print("")
                default:
                    break
                }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AmigoContactTracing.shared.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AmigoContactTracing.shared.applicationWillEnterForeground()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url),
            let dynamicUrl = dynamicLink.url {
            return LinkManager.shared.handleLink(url: dynamicUrl, isUniversalLink: false)
        }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
                return false
        }
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamicLink, error) in
            guard error == nil, let dynamicUrl = dynamicLink?.url else {
                return
            }
            _ = LinkManager.shared.handleLink(url: dynamicUrl, isUniversalLink: true)
        }
        return handled
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TempoMonitoring")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

