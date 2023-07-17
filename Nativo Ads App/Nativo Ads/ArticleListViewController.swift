//
//  ViewController.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK
import AppTrackingTransparency

class ArticleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var articlesDataSource  = Array<String>()
    var feedImgCache = Dictionary<URL, UIImage>()
    let dateFormatter = DateFormatter()
    let placeholderCellIdentifier = "placeholdercell"
    let VideoCellIdentifier = "videocell"
    let NativoReuseIdentifier = "nativoCell"
    let NativoSectionUrl = "http://www.nativo.com/demoapp"

    
    // The rows indexes where we want Nativo ads to load
    let placeholderRows = 12
    var nativoRows = [1, 4, 7, 10, 13, 16]
    var nextAdPos = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        // Register blank UITableViewCell to be used as container for Nativo ads
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NativoReuseIdentifier)
        
        // Initialize advertiser app tracking authorization
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                print("IDFA authorization: \(status.rawValue)")
                self.setupNativo()
            })
        }
        
        self.startArticleFeed()
    }
    
    func setupNativo() {
        NativoSDK.enableDevLogs()
        NativoSDK.disableAutoPrefetch(true)
        NativoSDK.setSectionDelegate(self, forSection: NativoSectionUrl)
        NativoSDK.register(UINib(nibName: "NativoAdViewAlt", bundle: nil), for: .native)
        NativoSDK.register(UINib(nibName: "NativoVideoAdView", bundle: nil), for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        NativoSDK.registerClass(NativoBannerView.classForCoder(), for: .standardDisplay)
        NativoSDK.prefetchAd(forSection: NativoSectionUrl)
    }
    
    func startArticleFeed() {
        articlesDataSource.removeAll()
        for _ in 0...placeholderRows {
            articlesDataSource.append("placeholder")
        }
    }
}

extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articlesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var didGetNativoAdFill = false
        var cell : UITableViewCell!
        let isNativoRow : Bool = nativoRows.contains(indexPath.row)
        if isNativoRow {
            // Dequeue the UITableViewCell we registered for Nativo Ads
            cell = tableView.dequeueReusableCell(withIdentifier: NativoReuseIdentifier, for: indexPath)
            // Use the NativoSDK to place an ad in the cell
            didGetNativoAdFill = NativoSDK.placeAd(in: cell,
                                                   atLocationIdentifier: indexPath,
                                                   inContainer: tableView,
                                                   forSection: NativoSectionUrl)
        }
        
        if !didGetNativoAdFill {
            cell = tableView.dequeueReusableCell(withIdentifier: placeholderCellIdentifier, for: indexPath)
        }
        
        return cell
    }
}


extension ArticleListViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
        if didGetFill, let nativoIndex = nextNativoIndex() {
            // Add Nativo ad to our datasource
            articlesDataSource.insert("nativo", at: nativoIndex.row)
            
            // Insert row into table
            tableView.insertRows(at: [nativoIndex], with: .automatic)
            
            // Prefetch next ad
            NativoSDK.prefetchAd(forSection: NativoSectionUrl)
        }
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation location: Any, container: UIView) {
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation location: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        if let index = location as? IndexPath {
            // Remove the Nativo placeholder from our datasource
            nativoRows.removeAll { val in
                if val == index.row {
                    articlesDataSource.remove(at: index.row)
                    return true;
                }
                return false;
            }
            
            // Update tableView
            self.tableView.reloadData()
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
    
    func nextNativoIndex() -> IndexPath? {
        if nextAdPos < nativoRows.count {
            let index = IndexPath(row: nativoRows[nextAdPos], section: 0)
            nextAdPos += 1
            return index
        }
        return nil
    }
    
    func reloadAds() {
        NativoSDK.clearAds(inSection: self.NativoSectionUrl, inContainer: nil)
        self.nativoRows = [1, 4, 7, 10, 13, 16]
        self.nextAdPos = 0
        self.startArticleFeed()
        self.tableView.reloadData()
    }
}


extension ArticleListViewController {
    
    func setupView() {
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
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
                    self.reloadAds()
                })
            ]
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem?.menu = actionMenu
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "ellipsis");
    }
}

