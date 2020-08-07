//
//  MainWebViewViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import WebKit

class MainWebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var url: String!
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navigationTitle
        
        startProgress()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        } else {
            show(.alert, message: Constants.Localizable.DEFAULT_ERROR_MESSAGE) {
                self.endProgress()
                
                self.closeWebView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = nil
    }
    
    private func closeWebView() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
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
extension MainWebViewViewController: WKUIDelegate {
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
extension MainWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        endProgress()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        endProgress()
        
        show(.alert, message: error.localizedDescription)
    }
}
