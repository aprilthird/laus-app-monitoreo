//
//  WelcomeOptionCollectionViewCell.swift
//  TempoMonitoring
//
//  Created by Hugo Andres on 20/02/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import UIKit

class WelcomeOptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionNameLabel: UILabel!
    static let reuseIdentifier: String = "welcomeOptionViewCell"
    private var gradientLayer: CAGradientLayer!
    var option: (text: String, imageUrl: String)! {
        didSet {
            guard option != nil else { return }
            if let url = URL(string: option.imageUrl) {
                optionImageView.setImage(url: url) { [weak self] in
                    self?.layoutSubviews()
                }
            }
            optionNameLabel.text = option.text
        }
    }
    var color: String? {
        didSet {
            let color = UIColor(self.color ?? "#293080")
            gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                color?.lighter(by: 70)?.cgColor ?? UIColor.lightGray.cgColor,
                color?.cgColor ?? UIColor.clear.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        [layer, gradientLayer].forEach { (layer) in
            layer?.cornerRadius = bounds.width / 10
        }
    }

}