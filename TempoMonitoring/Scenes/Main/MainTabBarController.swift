//
//  MainTabBarController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var mainPresenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.layer.shadowRadius = 6.0
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowOpacity = 0.8
        tabBar.layer.masksToBounds = false
    }
    
    func loadTabBar() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = UIColor("#999FBF")
        tabBar.tintColor = mainPresenter.getTintColor()
        
        setViewControllers(mainPresenter.getViewControllers(), animated: true)
        
        mainPresenter.validate()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainTabBarController: MainTabBarControllerProtocol {
    func showHomeBannerPopup(_ imageUrl: String, _ url: String) {
        let homeBanner = Router.shared.getHomeBannerPopup(imageUrl: imageUrl, url: url)
        homeBanner.modalPresentationStyle = .overCurrentContext
        homeBanner.modalTransitionStyle = .crossDissolve
        present(homeBanner, animated: true, completion: nil)
    }
    
    func showNewVersionPopup() {
        let newVersion = Router.shared.getNewVersionPopup()
        newVersion.modalPresentationStyle = .overCurrentContext
        newVersion.modalTransitionStyle = .crossDissolve
        present(newVersion, animated: true, completion: nil)
    }
}
