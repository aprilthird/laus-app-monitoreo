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
        // Initialization code
    }
    
}
