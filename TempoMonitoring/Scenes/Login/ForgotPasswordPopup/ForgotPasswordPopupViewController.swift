//
//  ForgotPasswordPopupViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Rosado on 11/1/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class ForgotPasswordPopupViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var popupTitleLabel: UILabel!
    var imageUrl: String!
    var message: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopup))
        backgroundView.addGestureRecognizer(tapGesture)
        
        if let url = URL(string: imageUrl) {
            popupImageView.setImage(url: url)
        }
        popupTitleLabel.text = message
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        popupView.layer.cornerRadius = popupView.bounds.width / 20.0
    }
    
    @objc private func closePopup() {
        dismiss(animated: true, completion: nil)
    }

}
