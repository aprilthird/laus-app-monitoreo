//
//  HomeBannerViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/31/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class HomeBannerViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    var url: String!
    var image: String! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.alpha = 0.5
        
        guard let url = URL(string: image) else {
            return
        }
        
        let width: CGFloat = UIScreen.main.bounds.width - 80
        let maximumHeight: CGFloat = UIScreen.main.bounds.height - 158
        var imageHeight: CGFloat = 0.0

        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                let scale: CGFloat
                if image.size.width > image.size.height {
                    scale = width / image.size.width
                } else {
                    scale = imageView.bounds.height / image.size.height
                }
                let realHeight = image.size.height * scale
                imageHeight = (realHeight < maximumHeight) ? realHeight : maximumHeight
            }
        }
        
        imageViewHeightConstraint.constant = imageHeight
        imageView.setImage(url: url) {
            self.viewDidLayoutSubviews()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 20
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.layer.shadowRadius = 3.0
        closeButton.layer.shadowColor = UIColor.gray.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        closeButton.layer.shadowOpacity = 0.7
    }
    
    @IBAction func didClosePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didOpenWebView(_ sender: UITapGestureRecognizer) {
        let mainTabBar = self.presentingViewController as? MainTabBarController
        let navigationController = mainTabBar?.selectedViewController as? UINavigationController
        
        dismiss(animated: false) {
            let webView = Router.shared.getMainWebView(title: nil, url: self.url)
            webView.hidesBottomBarWhenPushed = true
            navigationController?.show(webView, sender: nil)
        }
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
