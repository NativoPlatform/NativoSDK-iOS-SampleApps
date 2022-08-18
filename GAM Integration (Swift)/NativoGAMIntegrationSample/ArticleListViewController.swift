//
//  ViewController.swift
//  NativoGAMIntegrationSample
//
//  Copyright © 2019 Nativo. All rights reserved.
//

import UIKit
import NativoSDK
import GoogleMobileAds

class ArticleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var articlesDataSource  = Array<Dictionary<String, Any>>()
    var feedImgCache = Dictionary<URL, UIImage>()
    let dateFormatter = DateFormatter()
    let ArticleCellIdentifier = "articlecell"
    let VideoCellIdentifier = "videocell"
    let NativoCellIdentifier = "nativocell"
    let NativoSectionUrl = "http://www.nativo.net/mobiledfptest"
    let NativoAdRow1 = 3
    let NativoAdRow2 = 9
    
    var bannerAd: GAMBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NativoSDK.enableDevLogs()
        NativoSDK.enableGAMRequests(withVersion: "8.8.0");
        NativoSDK.setSectionDelegate(self, forSection: NativoSectionUrl)
        NativoSDK.registerReuseId(ArticleCellIdentifier, for: .native) // These identifiers correlate to the dynamic prototype cells set in Main.storyboard
        NativoSDK.registerReuseId(VideoCellIdentifier, for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        
        // Register blank cell to be used as container for Nativo ads
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NativoCellIdentifier)
        
        setupGAM()
        startArticleFeed()
    }
    
    func setupGAM() {
        GADMobileAds.sharedInstance().start { (status: GADInitializationStatus) in
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ kGADSimulatorID ]
            let nativoAdSize = GADAdSizeFromCGSize(kGADAdSizeNativoDefault)
            self.bannerAd = GAMBannerView(adSize: nativoAdSize)
            self.bannerAd.validAdSizes = [NSValueFromGADAdSize(nativoAdSize), NSValueFromGADAdSize(kGADAdSizeBanner)];
            self.bannerAd.adUnitID = "/416881364/AdUnitSDK"
            self.bannerAd.rootViewController = self
            self.bannerAd.delegate = self
            self.bannerAd.adSizeDelegate = self
            
            let request = GAMRequest()
            // You custom targeting value will be given to you by your Nativo account manager
            request.customTargeting = ["ntvPlacement" : "991150"]
            self.bannerAd.load(request)
        }
    }
}

extension ArticleListViewController : GADBannerViewDelegate, GADAdSizeDelegate, GADAppEventDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        let nativoAdSize = GADAdSizeFromCGSize(kGADAdSizeNativoDefault)
        if GADAdSizeEqualToSize(bannerView.adSize, nativoAdSize) {
            print("GAM :: Did recieve Nativo ad")
            bannerView.isHidden = true
            
            // Since this is the size of our Nativo ads, we pass this bannerView to Nativo where it will return the appropriate ad
            NativoSDK.makeGAMRequest(withBannerView: bannerView, forSection: NativoSectionUrl)
        } else {
            print("GAM :: Did recieve Banner ad")
            bannerView.isHidden = false
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner failed to receive ad")
    }
    
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        print("Banner will change to size %@", NSStringFromGADAdSize(size));
    }
    
}

extension ArticleListViewController: NtvSectionDelegate {
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
        if didGetFill {
            self.tableView.reloadData()
        }
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation identifier: Any, container: UIView) {
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation identifier: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        self.tableView.reloadData()
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


extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numAds = NativoSDK.getNumberOfAds(inSection: NativoSectionUrl, inTableOrCollectionSection: section, forNumberOfItemsInDatasource: self.articlesDataSource.count, inContainer: tableView)
        let totalRows = self.articlesDataSource.count + numAds
        print("-- Total Rows: \(totalRows)")
        return totalRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let isNativoAdPlacement: Bool = indexPath.row == NativoAdRow1
        var didGetNativoAdFill: Bool = false
        var cell: UITableViewCell! // Will always be initialized in this control flow so we can safely declare as implicitley unwrapped optional
        if isNativoAdPlacement {
            cell = tableView.dequeueReusableCell(withIdentifier: NativoCellIdentifier, for: indexPath)
            didGetNativoAdFill = NativoSDK.placeAd(in: cell, atLocationIdentifier: indexPath, inContainer: tableView, forSection: NativoSectionUrl)
        }
        
        if !didGetNativoAdFill {
            let articleCell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: ArticleCellIdentifier, for: indexPath) as! ArticleCell
            
            // Get the adjusted index path so we account for possible ad displacement in datasource
            let custom : IndexPath = NativoSDK.getAdjustedIndexPath(indexPath, forAdsInjectedInSection: NativoSectionUrl, inContainer: tableView)
            let row = custom.row
            let data = self.articlesDataSource[row]
            self.injectCell(articleCell, withData: data)
            cell = articleCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adAdjustedIndexPath : IndexPath = NativoSDK.getAdjustedIndexPath(indexPath, forAdsInjectedInSection: NativoSectionUrl, inContainer: tableView)
        if adAdjustedIndexPath.row < self.articlesDataSource.count {
            let articleItem = self.articlesDataSource[adAdjustedIndexPath.row]
            let articleUrlStr = "https://www.nativo.com\(articleItem["fullUrl"]!)"
            let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
            articleViewController.articleURL = URL(string: articleUrlStr)
            self.navigationController?.pushViewController(articleViewController, animated: true)
        }
    }
}

extension ArticleListViewController {
    
    func setupView() {
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
    }
    
    func startArticleFeed() {
        let filePath = Bundle.main.path(forResource: "nativoblog", ofType: "json")
        let feedData = try! Data.init(contentsOf: URL(fileURLWithPath: filePath!))
        let feed = try! JSONSerialization.jsonObject(with: feedData) as! Dictionary<String, Any>
        let feedItems = feed["items"] as! Array<Dictionary<String, Any>>
        self.articlesDataSource.append(contentsOf: feedItems)
    }
    
    func injectCell(_ cell: ArticleCell, withData data: Dictionary<String, Any> ) {
        cell.titleLabel.text = data["title"] as? String
        cell.authorNameLabel.text = data["author"] as? String
        cell.previewTextLabel.text = data["excerpt"] as? String
        cell.dateLabel.text = DateFormatter.localizedString(from: Date.init(), dateStyle: .medium, timeStyle: .short)
        let imgUrl = data["assetUrl"] as! String
        self.getAsyncImage(forUrl: URL.init(string: imgUrl)!) { (img) in
            if let articleImg = img {
                if cell.titleLabel.text == data["title"] as? String {
                    cell.adImageView.image = articleImg
                }
            }
        }
    }
    
    func getAsyncImage(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let image = self.feedImgCache[url]  {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            if let imgData = try? Data.init(contentsOf: url) {
                let image = UIImage.init(data: imgData)
                if (image != nil && url != nil) {
                    self.feedImgCache[url] = image
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}

