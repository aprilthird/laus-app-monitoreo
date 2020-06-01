//
//  AttentionWebViewViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import WebKit

class AttentionWebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var attentionPresenter: AttentionWebViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.Localizable.ATTENTION_TITLE
        
        navigationItem.setRightBarButtonItems(attentionPresenter.getRightNavigationItems(), animated: true)
        attentionPresenter.showWebView()
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
extension AttentionWebViewViewController: AttentionWebViewViewControllerProtocol {
    func openUrl(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        self.webView.load(URLRequest(url: url))
    }
    
    func showMoreSection() {
        let moreSection = Router.shared.getMoreSection()
        moreSection.hidesBottomBarWhenPushed = true
        show(moreSection, sender: nil)
    }
}
