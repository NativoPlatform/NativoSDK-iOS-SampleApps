//
//  AdTypesViewController.swift
//  Nativo Ads
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class AdTypesViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var articleAdView1: UIView!
    @IBOutlet weak var articleAdView2: UIView!
    @IBOutlet weak var articleAdView3: UIView!
    @IBOutlet weak var displayAdView1: UIView!
    @IBOutlet weak var displayAdView2: UIView!
    @IBOutlet weak var displayAdView3: UIView!
    @IBOutlet weak var videoAdView1: UIView!
    @IBOutlet weak var videoAdView2: UIView!
    @IBOutlet weak var videoAdView3: UIView!
    @IBOutlet weak var storyAdView1: UIView!
    @IBOutlet weak var storyAdView2: UIView!
    @IBOutlet weak var storyAdView3: UIView!
    @IBOutlet weak var stdAdView1: UIView!
    @IBOutlet weak var stdAdView2: UIView!
    @IBOutlet weak var stdDisplayLabel: UILabel!
    
    let articleSectionUrl = "http://www.nativo.com/article"
    let displaySectionUrl = "http://www.nativo.com/display"
    let videoSectionUrl = "http://www.nativo.com/video"
    let storySectionUrl = "http://www.nativo.com/story"
    let stdDisplaySectionUrl = "http://www.nativo.com/standarddisplay"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        NativoSDK.disableAutoPrefetch(true)
        NativoSDK.enablePlaceholderMode(true)
        NativoSDK.setSectionDelegate(self, forSection: articleSectionUrl)
        NativoSDK.setSectionDelegate(self, forSection: displaySectionUrl)
        NativoSDK.setSectionDelegate(self, forSection: videoSectionUrl)
        NativoSDK.setSectionDelegate(self, forSection: storySectionUrl)
        NativoSDK.setSectionDelegate(self, forSection: stdDisplaySectionUrl)
        prefetchAds()
    }
    
    func prefetchAds() {
        NativoSDK.prefetchAd(forSection: articleSectionUrl, atLocationIdentifier: 1, inContainer: scrollView)
        NativoSDK.prefetchAd(forSection: articleSectionUrl, atLocationIdentifier: 2, inContainer: scrollView, options: ["ntv_a" : "525631", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: articleSectionUrl, atLocationIdentifier: 3, inContainer: scrollView)
        
        NativoSDK.prefetchAd(forSection: displaySectionUrl, atLocationIdentifier: 1, inContainer: scrollView, options: ["ntv_a" : "534894", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: displaySectionUrl, atLocationIdentifier: 2, inContainer: scrollView)
        NativoSDK.prefetchAd(forSection: displaySectionUrl, atLocationIdentifier: 3, inContainer: scrollView)
        
        NativoSDK.prefetchAd(forSection: videoSectionUrl, atLocationIdentifier: 1, inContainer: scrollView, options: ["ntv_a" : "553602", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: videoSectionUrl, atLocationIdentifier: 2, inContainer: scrollView, options: ["ntv_a" : "553601", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: videoSectionUrl, atLocationIdentifier: 3, inContainer: scrollView, options: ["ntv_a" : "554152", "ntv_pl" : "1211528"])
        
        NativoSDK.prefetchAd(forSection: storySectionUrl, atLocationIdentifier: 1, inContainer: scrollView, options: ["ntv_a" : "463280", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: storySectionUrl, atLocationIdentifier: 2, inContainer: scrollView, options: ["ntv_a" : "445021", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: storySectionUrl, atLocationIdentifier: 3, inContainer: scrollView, options: ["ntv_a" : "526013", "ntv_pl" : "1211528"])
        
        NativoSDK.prefetchAd(forSection: stdDisplaySectionUrl, atLocationIdentifier: 1, inContainer: scrollView, options: ["ntv_a" : "553749", "ntv_pl" : "1211528"])
        NativoSDK.prefetchAd(forSection: stdDisplaySectionUrl, atLocationIdentifier: 1, inContainer: scrollView)
    }
    
    func setupNavBar() {
        let ntvLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ntvLogoView.contentMode = .scaleAspectFit
        ntvLogoView.image = UIImage(named: "AppLogo")
        navigationItem.titleView = ntvLogoView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))
        
        let actionMenu = UIMenu(
            title: "Actions",
            children: [
                UIAction(title: "Reload", image: UIImage(systemName: "gobackward"), handler: { action in
                })
            ]
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.menu = actionMenu
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "ellipsis");
    }

}

extension AdTypesViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation identifier: Any, container: UIView) {
        
        print("didAssignAd in \(sectionUrl) at \(String(describing: identifier))")
        var adView : UIView?
        
        switch sectionUrl {
        case articleSectionUrl:
            switch identifier as? Int {
            case 1:
                adView = articleAdView1
            case 2:
                adView = articleAdView2
            case 3:
                adView = articleAdView3
            default:
                adView = nil
            }
        case displaySectionUrl:
            switch identifier as? Int {
            case 1:
                adView = displayAdView1
            case 2:
                adView = displayAdView2
            case 3:
                adView = displayAdView3
            default:
                adView = nil
            }
        case videoSectionUrl:
            switch identifier as? Int {
            case 1:
                adView = videoAdView1
            case 2:
                adView = videoAdView2
            case 3:
                adView = videoAdView3
            default:
                adView = nil
            }
        case storySectionUrl:
            switch identifier as? Int {
            case 1:
                adView = storyAdView1
            case 2:
                adView = storyAdView2
            case 3:
                adView = storyAdView3
            default:
                adView = nil
            }
        case stdDisplaySectionUrl:
            switch identifier as? Int {
            case 1:
                adView = stdAdView1
            case 2:
                adView = stdAdView2
            default:
                adView = nil
            }
        default:
            adView = nil
        }
        
        // Place ad in view
        if adView != nil {
            NativoSDK.placeAd(in: adView!,
                              atLocationIdentifier: identifier,
                              inContainer: self.scrollView,
                              forSection: sectionUrl)
        }
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation identifier: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        if (sectionUrl == stdDisplaySectionUrl) {
            stdDisplayLabel.isHidden = true
        }
    }

    func section(_ sectionUrl: String, needsDisplayLandingPage sponsoredLandingPageViewController: (UIViewController & NtvLandingPageInterface)?) {
        if let landingPage = sponsoredLandingPageViewController {
            self.navigationController?.pushViewController(landingPage, animated: true)
        }
    }
    
    func section(_ sectionUrl: String, needsDisplayClickoutURL url: URL) {
        UIApplication.shared.open(url)
    }
}
