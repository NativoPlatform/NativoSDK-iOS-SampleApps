//
//  ViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import NativoSDK

class ArticleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var articlesDataSource  = Array<Dictionary<String, Any>>()
    var feedImgCache = Dictionary<URL, UIImage>()
    let dateFormatter = DateFormatter()
    let ArticleCellIdentifier = "articlecell"
    let VideoCellIdentifier = "videocell"
    let NativoReuseIdentifier = "nativoCell"
    let NativoSectionUrl = "http://www.publisher.com/test"
    
    // The rows indexes where we want Nativo ads to load
    var nativoRows = [1, 4, 7, 11, 15]
    var nextAdPos = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        startArticleFeed()
        
        // Wait for Active application state before requesting advertiser app tracking authorization (IDFA)
        if (UIApplication.shared.applicationState == .active) {
            self.requestTracking()
        } else {
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
                self.requestTracking()
            }
        }
    }
    
    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            // Tracking authorization completed. Start loading ads here.
            self.startNativo()
        })
    }
    
    func startNativo() {
        NativoSDK.enableDevLogs()
        NativoSDK.enableTestAdvertisements()
        NativoSDK.setSectionDelegate(self, forSection: self.NativoSectionUrl)
        NativoSDK.register(UINib(nibName: "NativoAdView", bundle: nil), for: .native)
        NativoSDK.register(UINib(nibName: "NativoVideoAdView", bundle: nil), for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        NativoSDK.registerClass(NativoBannerView.classForCoder(), for: .standardDisplay)
        // Register blank cell to be used as container for Nativo ads
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NativoReuseIdentifier)
    }
    
}

extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        // Check if this index path should be a Nativo ad unit
        let itemForIndex = articlesDataSource[indexPath.row]
        let isNativoItem = itemForIndex.contains { (key: String, value: Any) in
            return key == "Nativo"
        }
        if isNativoItem {
            // Dequeue the UITableViewCell we registered for Nativo Ads
            cell = tableView.dequeueReusableCell(withIdentifier: NativoReuseIdentifier)
            // Use NativoSDK to create ad unit
            NativoSDK.placeAd(in: cell,
                              atLocationIdentifier: indexPath,
                              inContainer: tableView, 
                              forSection: NativoSectionUrl)
        } else {
            // Create article cell as normal
            let articleCell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: ArticleCellIdentifier, for: indexPath) as! ArticleCell
            let data = self.articlesDataSource[indexPath.row]
            self.injectCell(articleCell, withData: data)
            cell = articleCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.articlesDataSource.count {
            let articleItem = self.articlesDataSource[indexPath.row]
            if let newsroomUrl = articleItem["fullUrl"] {
                let articleUrlStr = "https://www.nativo.com\(newsroomUrl)"
                let articleViewController = ArticleViewController(nibName: "ArticleViewController", bundle: nil)
                articleViewController.articleURL = URL(string: articleUrlStr)
                self.navigationController?.pushViewController(articleViewController, animated: true)
            }
        }
    }
    
}


extension ArticleListViewController: NtvSectionDelegate {
    
    // Helper function to find next IndexPath where Nativo ad should be
    func nextNativoIndex() -> IndexPath? {
        if nextAdPos < nativoRows.count {
            let index = IndexPath(row: nativoRows[nextAdPos], section: 0)
            nextAdPos += 1
            return index
        }
        return nil
    }
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
        // Add Nativo placeholder to our datasource if we get fill
        if didGetFill, let nativoIndex = nextNativoIndex() {
            articlesDataSource.insert(["Nativo" : nativoIndex.row], at: nativoIndex.row)
            
            // Insert row into table
            tableView.insertRows(at: [nativoIndex], with: .automatic)
        }
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation location: Any, container: UIView) {
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation location: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        if let index = location as? IndexPath {
            // Find the matching Nativo ad row
            if let matchingIndex = self.articlesDataSource.firstIndex(where: {
                let nativoIndex = ($0["Nativo"] as? Int)
                return nativoIndex == index.row
            }) {
                self.articlesDataSource.remove(at: matchingIndex)
                nativoRows.removeAll { $0 == index.row }
                // Delete matchingIndex from tableView
                self.tableView.deleteRows(at: [IndexPath(row: matchingIndex, section: 0)], with: .automatic)
            }
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
        self.articlesDataSource.append(contentsOf: feedItems)
        self.tableView.reloadData()
    }
    
    func injectCell(_ cell: ArticleCell, withData data: Dictionary<String, Any> ) {
        cell.titleLabel.text = data["title"] as? String
        cell.authorNameLabel.text = data["author"] as? String
        cell.previewTextLabel.text = data["excerpt"] as? String
        cell.dateLabel.text = DateFormatter.localizedString(from: Date.init(), dateStyle: .medium, timeStyle: .short)
        let imgUrl = data["assetUrl"] as? String
        if imgUrl != nil {
            ImageDownloader.shared.downloadImage(with: imgUrl, completionHandler: { img, success in
                if let articleImg = img {
                    if cell.titleLabel.text == data["title"] as? String {
                        cell.adImageView.image = articleImg
                    }
                }
            }, placeholderImage: nil)
        }
    }
    
    func setupNavBar() {
        let ntvLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ntvLogoView.contentMode = .scaleAspectFit
        ntvLogoView.image = UIImage(named: "AppLogo")
        navigationItem.titleView = ntvLogoView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))
        
        let privacyMenu = UIMenu(
            title: "Privacy Consent",
            children: [
                UIAction(title: "Give Consent", image: UIImage(systemName: "plus"), handler: { action in
                    UserDefaults.standard.set("BOXjEnFOXjEnFAKALBENB5-AAAAid7_______9______9uz_Gv_v_f__33e8__9v_l_7_-___u_-33d4-_1vf99yfm1-7ftr3tp_87ues2_Xur_959__3z3_EA", forKey: "IABTCF_TCString")
                    UserDefaults.standard.set("1YNY", forKey: "IABUSPrivacy_String")
                }),
                UIAction(title: "Remove Consent", image: UIImage(systemName: "minus"), handler: { action in
                    UserDefaults.standard.set(nil, forKey: "IABTCF_TCString")
                    UserDefaults.standard.set("1NNN", forKey: "IABUSPrivacy_String")
                })
            ]
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.menu = privacyMenu
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "hand.raised");
    }
}

