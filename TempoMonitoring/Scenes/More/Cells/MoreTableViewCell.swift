//
//  MoreTableViewCell.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    var option: (image: UIImage, type: MoreOptionType, title: String)! {
        didSet {
            guard option != nil else {
                return
            }
            
            optionImageView.image = option.image
            optionLabel.text = option.title.uppercased()
        }
    }
    static var reuseIdentifier: String? {
        return "optionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
