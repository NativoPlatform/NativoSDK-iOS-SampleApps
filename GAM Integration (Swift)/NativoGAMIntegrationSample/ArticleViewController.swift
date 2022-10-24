//
//  ArticleViewController.swift
//  NativoGAMIntegrationSample
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nativoAdView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var articleURL : URL?
    let spinner = UIActivityIndicatorView(style: .large)
    let ArticleNativoSectionUrl = "www.publisher/bottom-of-article"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Article"
        self.view.addSubview(spinner)
        self.spinner.center = self.view.center
        self.spinner.startAnimating()
                
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
    }
}
