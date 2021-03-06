//
//  ArticleViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2019 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nativoAdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var articleURL : URL?
    let spinner = UIActivityIndicatorView(style: .gray)
    let ArticleNativoSectionUrl = "www.publisher/bottom-of-article"

    override func viewDidLoad() {
        super.viewDidLoad()
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
                
        // Place bottom-of-article Nativo ad in view when webview has finished loading
        if self.nativoAdView.subviews.count == 0 {
            NativoSDK.placeAd(in: self.nativoAdView, atLocationIdentifier: self.articleURL as Any, inContainer: self.scrollView, forSection: ArticleNativoSectionUrl, options: nil)
        }
    }
}

extension ArticleViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, needsPlaceAdInViewAtLocation identifier: Any) {
        
    }
    
    func section(_ sectionUrl: String, needsRemoveAdViewAtLocation identifier: Any) {
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
        let webView = UIWebView(frame: clickoutAdVC.view.frame)
        clickoutAdVC.view.addSubview(webView)
        let clickoutReq = URLRequest(url: url)
        webView.loadRequest(clickoutReq)
        self.navigationController?.pushViewController(clickoutAdVC, animated: true)
    }
}
