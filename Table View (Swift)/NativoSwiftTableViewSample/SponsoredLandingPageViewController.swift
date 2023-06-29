//
//  SponsoredLandingPageViewController.swift
//  NativoSwiftTableViewSample
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
        UIApplication.shared.open(link)
    }
    
    func didLoadContent(withAd adData: NtvAdData) {
        self.adData = adData
        previewTextLabel.text = previewTextLabel.text?.uppercased()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sponsored Article"
        self.shareBtn = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action:#selector(socialShareButtonClick))
        self.navigationItem.rightBarButtonItem = self.shareBtn
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        // clear webview
        contentWKWebView.stopLoading()
        contentWKWebView.loadHTMLString("<html></html>", baseURL: nil)
    }
    
    @objc
    func socialShareButtonClick() {
        if let socialURL = self.shareUrl {
            let avc = UIActivityViewController(activityItems: [socialURL], applicationActivities: nil)
            avc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
                var sharePlatform = NtvSharePlatform.other
                if activityType == UIActivity.ActivityType.postToFacebook {
                    sharePlatform = NtvSharePlatform.facebook
                }
                else if activityType == UIActivity.ActivityType.postToTwitter {
                    sharePlatform = NtvSharePlatform.twitter
                }
                self.trackDidShare(sharePlatform)
            }
            self.present(avc, animated: true, completion: nil)
        }
    }

}
