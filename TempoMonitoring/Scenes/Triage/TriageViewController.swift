//
//  TriageViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class TriageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var triageImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    @IBOutlet weak var startTriageButton: UIButton!
    @IBOutlet weak var seeQRCodeButton: UIButton!
    @IBOutlet weak var lastCompletedTriageLabel: UILabel!
    var triagePresenter: TriagePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.Localizable.HOME_TITLE
        
        let loading = Constants.Localizable.LOADING
        
        startTriageButton.isEnabled = false
        seeQRCodeButton.isEnabled = false
        
        triageImageView.image = nil
        descriptionTextView.text = loading
        [subDescriptionLabel, lastCompletedTriageLabel].forEach { (label) in
            label?.text = loading
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        triagePresenter.loadElements(ofSize: lastCompletedTriageLabel.font.pointSize)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        triageImageView.layer.cornerRadius = triageImageView.bounds.height / 10
        [startTriageButton, seeQRCodeButton].forEach { (button) in
            button?.layer.cornerRadius = button!.bounds.height / 10
        }
    }
    
    @IBAction func didStartTriage(_ sender: UIButton) {
        triagePresenter.showTriageWebView()
    }
    
    @IBAction func didReadQRCode(_ sender: UIButton) {
        triagePresenter.showQRCodeWebView()
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
extension TriageViewController: TriageViewControllerProtocol {
    func showQRCodeReader() {
        let qrCodeReader = Router.shared.getQRCodeReader()
        qrCodeReader.hidesBottomBarWhenPushed = true
        show(qrCodeReader, sender: nil)
    }
    
    func showWebView(_ title: String?, _ url: String) {
        let webView = Router.shared.getMainWebView(title: title, url: url)
        webView.hidesBottomBarWhenPushed = true
        show(webView, sender: nil)
    }
    
    func updateRightNavigationItems(_ items: [UIBarButtonItem]) {
        navigationItem.setRightBarButtonItems(items, animated: true)
    }
    
    func updateViews(_ title: String, _ imageUrl: String?, _ description: String?, _ subDescription: String?, _ triageButtonText: String?, _ qrCodeButtonText: String?, _ lastTriage: NSAttributedString?) {
        navigationItem.title = title
        
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            triageImageView.isHidden = false
            triageImageView.setImage(url: url)
        } else {
            triageImageView.isHidden = true
        }
        
        if let description = description {
            descriptionTextView.isHidden = false
            descriptionTextView.text = description
        } else {
            descriptionTextView.isHidden = true
        }
        
        if let subDescription = subDescription {
            subDescriptionLabel.isHidden = false
            subDescriptionLabel.text = subDescription
        } else {
            subDescriptionLabel.isHidden = true
        }
        
        if let triageButtonText = triageButtonText {
            startTriageButton.setTitle(triageButtonText, for: .normal)
            startTriageButton.isHidden = false
            startTriageButton.isEnabled = true
        } else {
            startTriageButton.isHidden = true
            startTriageButton.isEnabled = false
        }
        
        if let qrCodeButtonText = qrCodeButtonText {
            seeQRCodeButton.setTitle(qrCodeButtonText, for: .normal)
            seeQRCodeButton.isHidden = false
            seeQRCodeButton.isEnabled = true
        } else {
            seeQRCodeButton.isHidden = true
            seeQRCodeButton.isEnabled = false
        }
        
        if let lastTriage = lastTriage {
            lastCompletedTriageLabel.attributedText = lastTriage
            lastCompletedTriageLabel.isHidden = false
        } else {
            lastCompletedTriageLabel.isHidden = true
        }
    }
}
