//
//  MoreHeaderView.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class MoreHeaderView: UIView {

    @IBOutlet weak var logoImageView: UIImageView!
    var imageOptions: (imageUrl: String, color: String?)? {
        didSet {
            guard imageOptions != nil,
                let url = URL(string: imageOptions?.imageUrl ?? "") else {
                    return
            }
            
            logoImageView.setImage(url: url) {
                self.layoutSubviews()
            }
            if let color = imageOptions?.color {
                logoImageView.backgroundColor = UIColor(color)
            }
        }
    }
    static var reuseIdentifier: String? {
        return "moreHeaderViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.layer.cornerRadius = logoImageView.bounds.height / 30
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
