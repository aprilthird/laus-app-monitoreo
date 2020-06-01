//
//  TipsHeaderCollectionReusableView.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class TipsHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var companyLogoImageView: UIImageView!
    var options: (backgroundColor: String, imageUrl: String, imageColor: String?)? {
        didSet {
            guard options != nil else {
                    return
            }
            
            if let backgroundColor = options?.backgroundColor {
                self.backgroundColor = UIColor(backgroundColor)
            }
            if let url = URL(string: options?.imageUrl ?? "") {
                companyLogoImageView.setImage(url: url) {
                    self.layoutSubviews()
                }
            }
            if let color = options?.imageColor {
                companyLogoImageView.backgroundColor = UIColor(color)
            }
        }
    }
    static var reuseIdentifier: String? {
        return "tipsHeaderViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        companyLogoImageView.layer.cornerRadius = companyLogoImageView.bounds.height / 30
    }
    
}
