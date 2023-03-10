//
//  QRCodeStatusViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit

class QRCodeStatusViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popupImageView: UIImageView!
    @IBOutlet weak var authorizationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var access: Bool?
    var name: String?
    var date: String?
    var text: String?
    var qrCodeStatusPresenter: QRCodeStatusPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.alpha = 0.5
        
        qrCodeStatusPresenter.loadPopup(access: access, name: name, date: date, text: text)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        popupView.layer.cornerRadius = popupView.bounds.width / 30
        popupView.backgroundColor = qrCodeStatusPresenter.getPopupBackgroundColor()
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.backgroundColor = qrCodeStatusPresenter.getCloseButtonBackgroundColor()
    }
    
    @IBAction func didCloseView(_ sender: Any) {
        closeView()
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
extension QRCodeStatusViewController: QRCodeStatusViewControllerProtocol {
    var isPopupHidden: Bool {
        get {
            return popupView.isHidden
        }
        set {
            popupView.isHidden = newValue
        }
    }
    
    func closeView() {
        let navigationController = self.presentingViewController as? UINavigationController
        
        dismiss(animated: false) {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updatePopup(_ title: String?, _ subtitle: String?, _ image: UIImage, _ authorization: String, _ description: String?) {
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        if let subtitle = subtitle {
            dateLabel.text = subtitle
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        popupImageView.image = image
        authorizationLabel.text = authorization
        if let description = description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
    }
}
