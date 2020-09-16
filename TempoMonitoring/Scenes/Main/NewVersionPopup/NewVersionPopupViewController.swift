//
//  NewVersionPopupViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class NewVersionPopupViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    var newVerionPresenter: NewVersionPopupPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.alpha = 0.5
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        popupView.layer.cornerRadius = 10
        popupView.backgroundColor = newVerionPresenter.getBackgroundColor()
        updateButton.layer.cornerRadius = updateButton.bounds.height / 2
        updateButton.backgroundColor = newVerionPresenter.getButtonBackgroundColor()
    }

    @IBAction func didUpdateApp(_ sender: UIButton) {
        guard let url = URL(string: "itms-apps://apps.apple.com/pe/app/id1521181252") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
