//
//  ArticleViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class PlaceholderArticleViewController: UIViewController {
    
    @IBOutlet weak var nativoAdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let ArticleNativoSectionUrl = "www.nativo.com/demoapp"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Article"
        
        // Render Nativo Article Ad Unit
        NativoSDK.setSectionDelegate(self, forSection: ArticleNativoSectionUrl)
    }
}

extension PlaceholderArticleViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
        if didGetFill {
            NativoSDK.placeAd(in: self.nativoAdView,
                              atLocationIdentifier:1,
                              inContainer: self.scrollView,
                              forSection: ArticleNativoSectionUrl,
                              options: nil)
        }
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation identifier: Any, container: UIView) {
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation identifier: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        // Set height to 0 instead of remove (If removed from parent view you will need to reapply autolayout constraints)
        self.nativoAdView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        print("Removed Nativo ad view")
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
