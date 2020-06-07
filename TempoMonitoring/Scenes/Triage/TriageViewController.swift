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
    @IBOutlet weak var startTriageButton: UIButton!
    @IBOutlet weak var seeQRCodeButton: UIButton!
    @IBOutlet weak var lastCompletedTriageLabel: UILabel!
    var triagePresenter: TriagePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.Localizable.TRIAGE_TITLE
        
        lastCompletedTriageLabel.text = triagePresenter.loadLastTriage(ofSize: lastCompletedTriageLabel.font.pointSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setRightBarButtonItems(triagePresenter.getRightNavigationItems(), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    func updateLastTriage(_ isHidden: Bool, _ attributedText: NSAttributedString?) {
        lastCompletedTriageLabel.isHidden = isHidden
        guard let attributedText = attributedText else { return }
        lastCompletedTriageLabel.attributedText = attributedText
    }
}
