//
//  OfflinePopupViewController.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 3/10/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

class OfflinePopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapTerminar(_ sender: Any) {
        let mainTabBar = Router.shared.getMainTabBar()
        crossDisolveTransition(to: mainTabBar)
    }
}
