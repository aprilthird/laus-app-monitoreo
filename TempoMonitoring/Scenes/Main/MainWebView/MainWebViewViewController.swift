//
//  MainWebViewViewController.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

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
        let webUrl = url.contains("http") ? url : "https://" + url
        if let url = URL(string: webUrl ?? "") {
            webView.load(URLRequest(url: url))
        } else {
            show(.alert, message: Constants.Localizable.DEFAULT_ERROR_MESSAGE) { [weak self] in
                self?.endProgress()
                self?.closeWebView()
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
    
    private func downloadPDF(url: URL) {
        startProgress()
        let task = URLSession.shared.downloadTask(with: url) { [weak self] (localUrl, response, error) in
            guard let self = self else { return }
            self.endProgress()
            do {
                guard let localUrl = localUrl,
                      let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    throw NSError()
                }
                let destinationUrl = documentsPath.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.removeItem(at: destinationUrl)
                try FileManager.default.copyItem(at: localUrl, to: destinationUrl)
                
                self.showQuestion(.alert, title: Constants.Localizable.SUCCESSFUL_DOWNLOAD, message: Constants.Localizable.SUCCESSFUL_PDF_DOWNLOAD_MESSAGE, yes: Constants.Localizable.GO_TO_FILES_APP, no: Constants.Localizable.CANCEL) { (isSuccessful) in
                    let path = documentsPath.absoluteString.replacingOccurrences(of: "file://", with: "shareddocuments://")
                    if isSuccessful, let filesAppUrl = URL(string: path) {
                        UIApplication.shared.open(filesAppUrl, options: [:], completionHandler: nil)
                    }
                    self.closeWebView()
                }
            } catch _ {
                self.show(.alert, message: Constants.Localizable.DEFAULT_ERROR_MESSAGE) {
                    self.closeWebView()
                }
            }
        }
        task.resume()
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.absoluteString.suffix(5).contains(".pdf") else {
            decisionHandler(.allow)
            return
        }
        showQuestion(.alert, message: Constants.Localizable.DOWNLOAD_PDF_QUESTION) { [weak self] (isSuccesful) in
            if isSuccesful {
                self?.downloadPDF(url: url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
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
