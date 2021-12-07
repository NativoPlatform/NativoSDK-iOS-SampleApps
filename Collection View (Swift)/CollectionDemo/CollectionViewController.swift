//
//  CollectionViewController.swift
//  CollectionDemo
//
//  Copyright © 2019 Nativo. All rights reserved.
//

import UIKit
import NativoSDK
import AdSupport
import AppTrackingTransparency


class CollectionViewController: UICollectionViewController {
    
    var feedImgCache = Dictionary<URL, UIImage>()
    let ReuseIdentifier = "Cell"
    let NativoReuseIdentifier = "nativoCell"
    let SectionUrl = "publisher.com/home"
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = CGSize(width: 342.0, height: 300.0)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14, *) {
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
        

        

        
        
        // Register specialized collectionViewCell for Nativo
        self.collectionView.register(NtvCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NativoReuseIdentifier)
        self.collectionView.prefetchDataSource = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell! // Will always be initialized in this control flow so we can safely declare as implicitley unwrapped optional
        var didGetNativoAdFill: Bool = false
        let isNativoAdPlacement: Bool = isNativoIndexPath(indexPath)
        if isNativoAdPlacement {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NativoReuseIdentifier, for: indexPath)
            didGetNativoAdFill = NativoSDK.placeAd(in: cell, atLocationIdentifier: indexPath, inContainer: collectionView, forSection: SectionUrl)
        }
        
        if !didGetNativoAdFill {
            let articleCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath) as! CollectionViewCell
            articleCell.titleLabel.text = "Lorum Ipsom"
            articleCell.authorNameLabel.text = "John"
            articleCell.previewTextLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"
            let imgUrl = URL.init(string: "https://images.unsplash.com/photo-1527664557558-a2b352fcf203?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=4341976025ae49162643ccdb47a72a4d&w=1000&q=80")
            let authorUrl = URL.init(string: "https://www.logolynx.com/images/logolynx/6a/6aa959dca0e6c62f593e94e02332a67f.jpeg")
            getAsyncImage(forUrl: imgUrl!) { (img) in
                articleCell.adImageView.image = img
            }
            getAsyncImage(forUrl: authorUrl!) { (authorimg) in
                articleCell.authorImageView.image = authorimg
            }
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
    
    func getAsyncImage(forUrl url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).sync {
            if let image = self.feedImgCache[url]  {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            if let imgData = try? Data.init(contentsOf: url) {
                let image = UIImage.init(data: imgData)
                if (image != nil) {
                    self.feedImgCache[url] = image
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }

}

extension CollectionViewController: NtvSectionDelegate {
    
    func section(_ sectionUrl: String, needsPlaceAdInViewAtLocation identifier: Any) {
        self.collectionView.reloadData()
    }
    
    func section(_ sectionUrl: String, needsRemoveAdViewAtLocation identifier: Any) {
        self.collectionView.reloadData()
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

extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Prefetch Nativo SDK ads at specified index paths
        for indexPath in indexPaths {
            if isNativoIndexPath(indexPath) {
                NativoSDK.prefetchAd(forSection: SectionUrl, atLocationIdentifier: indexPath, options: nil)
            }
        }
    }

}

