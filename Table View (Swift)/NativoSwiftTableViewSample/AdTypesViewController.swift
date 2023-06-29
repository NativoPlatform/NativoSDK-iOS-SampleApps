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
    @IBOutlet weak var articleContainer1: UIView!
    @IBOutlet weak var articleContainer2: UIView!
    @IBOutlet weak var articleContainer3: UIView!
    @IBOutlet weak var displayContainer1: UIView!
    @IBOutlet weak var displayContainer2: UIView!
    @IBOutlet weak var displayContainer3: UIView!
    @IBOutlet weak var videoContainer1: UIView!
    @IBOutlet weak var videoContainer2: UIView!
    @IBOutlet weak var videoContainer3: UIView!
    @IBOutlet weak var storyContainer1: UIView!
    @IBOutlet weak var storyContainer2: UIView!
    @IBOutlet weak var storyContainer3: UIView!
    @IBOutlet weak var stdContainer1: UIView!
    @IBOutlet weak var stdContainer2: UIView!
    
    let articleSectionUrl = "http://www.nativo.com/article"
    let displaySectionUrl = "http://www.nativo.com/display"
    let videoSectionUrl = "http://www.nativo.com/video"
    let storySectionUrl = "http://www.nativo.com/story"
    let stdDisplaySectionUrl = "http://www.nativo.com/standarddisplay"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        NativoSDK.prefetchAd(forSection: articleSectionUrl, atLocationIdentifier: 3, inContainer: scrollView, options: ["ntv_a" : "530424", "ntv_pl" : "1211528"])
        
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
}

extension AdTypesViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation identifier: Any, container: UIView) {
        print("didAssignAd in \(sectionUrl) at \(String(describing: identifier))")
        var adContainer : UIView?
        switch sectionUrl {
        case articleSectionUrl:
            switch identifier as? Int {
            case 1:
                adContainer = articleContainer1
            case 2:
                adContainer = articleContainer2
            case 3:
                adContainer = articleContainer3
            default:
                adContainer = nil
            }
        case displaySectionUrl:
            switch identifier as? Int {
            case 1:
                adContainer = displayContainer1
            case 2:
                adContainer = displayContainer2
            case 3:
                adContainer = displayContainer3
            default:
                adContainer = nil
            }
        case videoSectionUrl:
            switch identifier as? Int {
            case 1:
                adContainer = videoContainer1
            case 2:
                adContainer = videoContainer2
            case 3:
                adContainer = videoContainer3
            default:
                adContainer = nil
            }
        case storySectionUrl:
            switch identifier as? Int {
            case 1:
                adContainer = storyContainer1
            case 2:
                adContainer = storyContainer2
            case 3:
                adContainer = storyContainer3
            default:
                adContainer = nil
            }
        case stdDisplaySectionUrl:
            switch identifier as? Int {
            case 1:
                adContainer = stdContainer1
            case 2:
                adContainer = stdContainer2
            default:
                adContainer = nil
            }
        default:
            adContainer = nil
        }
        
        // Place ad in the container
        if adContainer != nil {
            NativoSDK.placeAd(in: adContainer!,
                              atLocationIdentifier: identifier,
                              inContainer: self.scrollView,
                              forSection: sectionUrl)
        }
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation identifier: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        // Set height to 0 instead of remove (If removed from parent view you will need to reapply autolayout constraints)
        //self.nativoAdView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        print("Removed Nativo ad view in \(sectionUrl) at \(String(describing: identifier))")
    }

    func section(_ sectionUrl: String, needsDisplayLandingPage sponsoredLandingPageViewController: (UIViewController & NtvLandingPageInterface)?) {
        if let landingPage = sponsoredLandingPageViewController {
            self.present(landingPage, animated: true)
        }
    }
    
    func section(_ sectionUrl: String, needsDisplayClickoutURL url: URL) {
        UIApplication.shared.open(url)
    }
}
