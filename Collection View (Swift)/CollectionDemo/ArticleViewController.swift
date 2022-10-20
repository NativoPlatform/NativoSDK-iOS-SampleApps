//
//  ArticleViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleViewController: UIViewController {
    
    let spinner = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(spinner)
        self.spinner.center = self.view.center
        self.spinner.startAnimating()
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        self.navigationItem.title = "Article"
        
        if let webUrl = URL(string: "http://dsp.test-sites.internal.nativo.net/external/moblie_web.html") {
            webView.load(URLRequest(url: webUrl))
        }
    }
}

extension ArticleViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        // Place middle-of-article ad in web view
        NativoSDK.placeAd(in: webView, forSection: "http://www.nativo.net/moap")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Loads requests from iframes
        webView.load(navigationAction.request)
        return nil;
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // Allow links to be clicked
        decisionHandler(.allow);
    }
    
}
