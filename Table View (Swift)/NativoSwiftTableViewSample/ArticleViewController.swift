//
//  ArticleViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nativoAdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var articleURL : URL?
    let spinner = UIActivityIndicatorView(style: .medium)
    let ArticleNativoSectionUrl = "www.publisher/bottom-of-article"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Article"
        self.view.addSubview(spinner)
        self.spinner.center = self.view.center
        self.spinner.startAnimating()
        
        NativoSDK.setSectionDelegate(self, forSection: ArticleNativoSectionUrl)
        
        if let url = self.articleURL {
            self.webView.navigationDelegate = self;
            self.webView.load(URLRequest(url: url))
        }
    }
}

extension ArticleViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
        self.webView.expandToFitContents()
        
        // Wait until web view finished loading to render bottom-of-article Nativo ad
        NativoSDK.placeAd(in: self.nativoAdView, atLocationIdentifier:self.articleURL as Any, inContainer: self.scrollView, forSection: ArticleNativoSectionUrl, options: nil)
    }
}

extension ArticleViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {

    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation identifier: Any, container: UIView) {
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation identifier: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        // Set height to 0 instead of remove (If removed from parent view you will need to reapply autolayout constraints)
        self.nativoAdView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        print("Removed Nativo ad view")
    }
    
    func section(_ sectionUrl: String, registerNibNameFor templateType: NtvAdTemplateType, atLocationIdentifier locationIdentifier: Any) -> String? {
        switch templateType {
            
        case .native:
            return "ArticleCell"
        
        case .video:
            return "ArticleVideoAdCell"
            
        default:
            return nil
        }
    }

    func section(_ sectionUrl: String, needsDisplayLandingPage sponsoredLandingPageViewController: (UIViewController & NtvLandingPageInterface)?) {
        if let landingPage = sponsoredLandingPageViewController {
            self.navigationController?.pushViewController(landingPage, animated: true)
        }
    }
    
    func section(_ sectionUrl: String, needsDisplayClickoutURL url: URL) {
        let clickoutAdVC = UIViewController()
        let webView = WKWebView(frame: clickoutAdVC.view.frame)
        let clickoutReq = URLRequest(url: url)
        webView.load(clickoutReq)
        self.navigationController?.pushViewController(clickoutAdVC, animated: true)
        clickoutAdVC.view.addSubview(webView)
    }
}
