//
//  AttentionWebViewViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import dp3t_lib_ios
import WebKit

class AttentionWebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var attentionPresenter: AttentionWebViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.Localizable.ATTENTION_TITLE
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        attentionPresenter.showWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setRightBarButtonItems(attentionPresenter.getRightNavigationItems(), animated: true)
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
    func goBack() {
        webView.goBack()
    }
    
    func openUrl(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        self.webView.load(URLRequest(url: url))
    }
    
    func showContactTracing() {
        AmigoContactTracing.shared.launch(themeColor: attentionPresenter.getTintColor())
    }
    
    func showMoreSection() {
        let moreSection = Router.shared.getMoreSection()
        moreSection.hidesBottomBarWhenPushed = true
        show(moreSection, sender: nil)
    }
}
extension AttentionWebViewViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard navigationAction.targetFrame == nil, let url = navigationAction.request.url else {
            return nil
        }
        let urlString = url.absoluteString
        if urlString.lowercased().contains("http") || urlString.lowercased().contains("https") {
            webView.load(URLRequest(url: url))
        } else if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        show(.alert, message: message, closure: completionHandler)
    }
}
extension AttentionWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.setLeftBarButtonItems(attentionPresenter.getLeftNavigationItems(canGoBack: webView.canGoBack), animated: true)
    }
}
