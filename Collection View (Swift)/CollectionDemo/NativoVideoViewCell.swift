//
//  NativoVideoViewCell.swift
//  CollectionDemo
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import UIKit
import NativoSDK
import OSLog

class NativoVideoViewCell: UICollectionViewCell, NtvVideoAdInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displaySponsoredIndicators(_ isSponsored: Bool) {
        if isSponsored {
            self.contentView.backgroundColor = UIColor(red: 0.906, green: 0.941, blue: 1.000, alpha: 1.000)
        }
    }
    
    func shouldPrependAuthorByline() -> Bool {
        return false
    }
    
    var videoEventListener: NtvVideoEventListener {
        get { self }
    }
}

extension NativoVideoViewCell : NtvVideoEventListener {
    
    func videoPlayer(_ player: NtvVideoPlayer, stateChanged state: NtvVideoState) {
        print("Video state: \(state)")
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, progressChanged progress: Int, withAd adData: NtvAdData) {
        
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, didGoFullScreenWithAd adData: NtvAdData) {
        
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, didExitFullScreenWithAd adData: NtvAdData) {
        
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, learnMoreClicked adData: NtvAdData) {
        
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, didFailWithError error: Error?, withAd adData: NtvAdData) {
        
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, shouldDeactiveAudioSessionWithReason reason: String) -> Bool {
        return true
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, shouldModifyAudioSessionCategory category: String, withReason reason: String) -> Bool {
        return true
    }
}

