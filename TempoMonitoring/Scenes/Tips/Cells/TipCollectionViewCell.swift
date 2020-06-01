//
//  TipCollectionViewCell.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class TipCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tipImageView: UIImageView!
    @IBOutlet weak var tipNameLabel: UILabel!
    var tip: (imageUrl: String, name: String, url: String)! {
        didSet {
            guard tip != nil else {
                return
            }
            
            if let url = URL(string: tip.imageUrl) {
                tipImageView.setImage(url: url) {
                    self.tipImageView.backgroundColor = .black
                    self.tipImageView.layoutSubviews()
                }
            }
            tipNameLabel.text = tip.name.uppercased()
        }
    }
    static var reuseIdentifier: String? {
        return "tipViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tipImageView.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tipImageView.layer.opacity = 0.8
        layer.cornerRadius = bounds.height / 20
    }

}
