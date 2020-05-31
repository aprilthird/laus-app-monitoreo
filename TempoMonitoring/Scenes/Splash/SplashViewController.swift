//
//  SplashViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    var splashPresenter: SplashPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splashPresenter.startAnimation()
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
extension SplashViewController: SplashViewControllerProtocol {
    func goToFirstScene() {
        let firstScene = Router.shared.getFirstScene()
        let navigationController = Router.shared.getTempoNavigationController(firstScene)
        crossDisolveTransition(to: navigationController)
    }
    
    func goToMain() {
        let mainTabBar = Router.shared.getMainTabBar()
        crossDisolveTransition(to: mainTabBar)
    }
}
