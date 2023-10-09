//
//  CollectionViewController.swift
//  CollectionDemo
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK
import AdSupport
import AppTrackingTransparency


class CollectionViewController: UICollectionViewController {
    
    var feedImgCache = Dictionary<URL, UIImage>()
    let ReuseIdentifier = "Cell"
    let NativoReuseIdentifier = "nativoCell"
    let SectionUrl = "www.nativo.net/test"
    var articleDatasource = Array<String>()
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = CGSize(width: 342.0, height: 300.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        // Initialize advertiser app tracking authorization
        if (UIApplication.shared.applicationState == .active) {
            print("active")
            self.requestTracking()
        } else {
            print("background?")
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
                self.requestTracking()
            }
        }

        
        // Register specialized collectionViewCell for Nativo
        self.collectionView.register(NtvCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NativoReuseIdentifier)
    }

    func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            // Tracking authorization completed. Start loading ads here.
            print("idfa request complete")

            let status = ATTrackingManager.trackingAuthorizationStatus
            print("IDFA status: \(status)")
            if status == .authorized {
                let idfaVal = ASIdentifierManager.shared().advertisingIdentifier
                print("Idfa val: \(idfaVal)")
            }

            NativoSDK.enableDevLogs()
            NativoSDK.enableTestAdvertisements()
            NativoSDK.setSectionDelegate(self, forSection: self.SectionUrl)
            NativoSDK.registerReuseId(self.ReuseIdentifier, for: .native) // reuseIdentifier "Cell" comes from Main.storyboard dynamic prototype cell
            NativoSDK.register(UINib(nibName: "NativoVideoViewCell", bundle: nil), for: .video)
            NativoSDK.register(UINib(nibName: "SponsoredLandingPageViewController", bundle: nil), for: .landingPage)
        })
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Datasource Count: \(articleDatasource.count)")
        return articleDatasource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell! // Will always be initialized in this control flow so we can safely declare as implicitley unwrapped optional
        
        var didGetNativoAdFill: Bool = false
        if isNativoIndexPath(indexPath) {
            // Call Nativo placeAdInView and check returned boolean to see ad placement was successful
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NativoReuseIdentifier, for: indexPath)
            didGetNativoAdFill = NativoSDK.placeAd(in: cell, atLocationIdentifier: indexPath, inContainer: collectionView, forSection: SectionUrl)
        }
        
        // Create an article cell if no Nativo ad fill
        if !didGetNativoAdFill {
            let articleCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath) as! CollectionViewCell
            let title = articleDatasource[indexPath.row]
            injectGenericArticle(inCell: articleCell, withTitle: title)
            cell = articleCell
        }
        
        // set cell width
        if let widthcell = cell as? NtvCollectionViewCellMaxWidthDelegate {
            let contentInset = collectionView.contentInset.left + collectionView.contentInset.right
            let sectionInset = collectionLayout.sectionInset.left + collectionLayout.sectionInset.right
            let maxWidth = collectionView.frame.size.width - contentInset - sectionInset
            widthcell.setMaxWidth(maxWidth);
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleViewController = ArticleViewController()
        self.navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func isNativoIndexPath(_ indexPath: IndexPath) -> Bool {
        // Determine where Nativo ad unit should go
        let adStartRow = 1
        let adIntervalRow = 3
        return indexPath.row % adIntervalRow == adStartRow
    }
    
    func injectGenericArticle(inCell cell: CollectionViewCell, withTitle title: String) {
        cell.titleLabel.text = title
        cell.authorNameLabel.text = "John"
        cell.previewTextLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
        let imgUrl = "https://images.unsplash.com/photo-1527664557558-a2b352fcf203?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=4341976025ae49162643ccdb47a72a4d&w=1000&q=80"
        let authorUrl = "https://www.logolynx.com/images/logolynx/6a/6aa959dca0e6c62f593e94e02332a67f.jpeg"
        ImageDownloader.shared.downloadImage(with: imgUrl, completionHandler: { theImage, success in
            cell.adImageView.image = theImage
        }, placeholderImage: nil)
        ImageDownloader.shared.downloadImage(with: authorUrl, completionHandler: { theImage, success in
            cell.authorImageView.image = theImage
        }, placeholderImage: nil)
    }
    
    func setupNavBar() {
        let ntvLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ntvLogoView.contentMode = .scaleAspectFit
        ntvLogoView.image = UIImage(named: "AppIcon")
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
    
    func initDatasource() {
        for i in 1...20 {
            self.articleDatasource.append("Article \(i)")
        }
        self.collectionView.reloadData()
    }
}

extension CollectionViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, didReceiveAd didGetFill: Bool) {
        // Wait for Nativo to load before initializing
        if (articleDatasource.isEmpty) {
            self.initDatasource()
        }
    }
    
    func section(_ sectionUrl: String, didAssignAd adData: NtvAdData, toLocation location: Any, container: UIView) {
        print("didAssignAdAtLocation \(String(describing: location))")
        if let index = location as? IndexPath {
            // Add Nativo placeholder to our datasource, so that we offset correctly
            articleDatasource.insert("Nativo", at: index.row)
        }
        
    }
    
    func section(_ sectionUrl: String, didFailAdAtLocation location: Any?, in view: UIView?, withError errMsg: String?, container: UIView?) {
        print("didFailAdAtLocation \(String(describing: location))")
        if let index = location as? IndexPath {
            // Remove Nativo cell from our datasource, so that we offset correctly
            if articleDatasource[index.row].contains("Nativo") {
                articleDatasource.remove(at: index.row)
                self.collectionView.deleteItems(at: [index])
            }
        } else {
            if (articleDatasource.isEmpty) {
                self.initDatasource()
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

