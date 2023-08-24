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
    var firstLaunch = true

    // The rows indexes where we want Nativo ads to load
    let articleRows = 12
    var nativoRows = [1, 4, 7, 10, 13, 16]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        
        // Register blank UITableViewCell to be used as container for Nativo ads
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NativoReuseIdentifier)
        
        // Wait for app to become active before requesting ATT tracking authorization
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
            if self.firstLaunch {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    // Tracking authorization completed. Start loading ads here.
                    self.setupNativo()
                    self.startArticleFeed()
                })
                self.firstLaunch = false
            }
        }
    }
    
    func setupNativo() {
        //NSLog("Starting Nativo")
        NativoSDK.enableDevLogs()
        NativoSDK.setSectionDelegate(self, forSection: NativoSectionUrl)
        NativoSDK.register(UINib(nibName: "NativoAdViewAlt", bundle: nil), for: .native)
        NativoSDK.register(UINib(nibName: "NativoVideoAdView", bundle: nil), for: .video)
        NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        NativoSDK.registerClass(NativoBannerView.classForCoder(), for: .standardDisplay)
    }
    
    func startArticleFeed() {
        //NSLog("Starting feed")
        articlesDataSource.removeAll()
        for i in 0...articleRows {
            articlesDataSource.append("article \(i)")
        }
        tableView.reloadData()
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

    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation location: Any, container: UIView) {
        // Add Nativo ad to our datasource
        let indexPath = (location as! IndexPath)
        articlesDataSource.insert("nativo", at: indexPath.row)

        // Insert row into table
        tableView.insertRows(at: [indexPath], with: .automatic)
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
    
    func reloadAds() {
        NativoSDK.clearAds(inSection: self.NativoSectionUrl, inContainer: nil)
        self.nativoRows = [1, 4, 7, 10, 13, 16]
        self.startArticleFeed()
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

