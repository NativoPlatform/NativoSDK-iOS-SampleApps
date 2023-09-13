//
//  SponsoredLandingPageViewController.swift
//  CollectionDemo
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class SponsoredLandingPageViewController: UIViewController, NtvLandingPageInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var contentWKWebView: WKWebView!

    var shareUrl: String?
    var trackDidShare: TrackDidShareBlock!
    var shareBtn : UIBarButtonItem?
    var adData : NtvAdData?
    
    func handleExternalLink(_ link: URL) {
        // Load click-out url in WKWebView
        let clickoutAdViewController = UIViewController.init()
        let webView = WKWebView.init(frame: clickoutAdViewController.view.frame)
        clickoutAdViewController.view.addSubview(webView)
        let clickoutReq = URLRequest.init(url: link)
        webView.load(clickoutReq)
        self.navigationController?.pushViewController(clickoutAdViewController, animated: true)
    }
    
    func didLoadContent(withAd adData: NtvAdData) {
        self.adData = adData
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareBtn = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action:#selector(socialShareButtonClick))
        self.navigationItem.rightBarButtonItem = self.shareBtn
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.contentWKWebView.stopLoadingNativo()
    }
    
    @objc
    func socialShareButtonClick() {
        if let socialURL = self.shareUrl {
            let avc = UIActivityViewController(activityItems: [socialURL], applicationActivities: nil)
            avc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
                if (completed) {
                    var sharePlatform = NtvSharePlatform.other
                    if activityType == UIActivity.ActivityType.postToFacebook {
                        sharePlatform = NtvSharePlatform.facebook
                    }
                    else if activityType == UIActivity.ActivityType.postToTwitter {
                        sharePlatform = NtvSharePlatform.twitter
                    }
                    self.trackDidShare(sharePlatform)
                }
            }
            self.present(avc, animated: true, completion: nil)
        }
    }

}
