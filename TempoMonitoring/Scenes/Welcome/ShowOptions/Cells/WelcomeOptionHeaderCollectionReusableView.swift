//
//  WelcomeOptionHeaderCollectionReusableView.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

class WelcomeOptionHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var offlineView: UIView!
    
    static let reuseIdentifier: String = "welcomeOptionHeaderViewCell"
    var option: (title: String, subtitle: String)! {
        didSet {
            guard option != nil else { return }
            titleLabel.text = option.title
            subtitleLabel.text = option.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        offlineView.isHidden = true
    }
    
    func showBanneroffline(){
        offlineView.isHidden = false
        
        offlineView.layer.cornerRadius = 4
        offlineView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        offlineView.layer.shadowOffset = CGSize(width: 0, height: 4)
        offlineView.layer.shadowRadius = 4
        offlineView.layer.shadowOpacity = 1
        offlineView.layer.masksToBounds = false
    }
}
