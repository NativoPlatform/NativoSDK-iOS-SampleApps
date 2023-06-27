//
//  ArticleVideoAdCell.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class NativoVideoAdView: UIView, NtvVideoAdInterface {
    
    // NtvVideoAdInterface protocol properties set from IBOutlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func shouldPrependAuthorByline() -> Bool {
        false
    }
    
    var videoEventListener: NtvVideoEventListener {
        self
    }
}

extension NativoVideoAdView: NtvVideoEventListener {
    func videoPlayer(_ player: NtvVideoPlayer, stateChanged state: NtvVideoState) {
        
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
    
    func videoPlayer(_ player: NtvVideoPlayer, shouldModifyAudioSessionCategory category: String, withReason reason: String) -> Bool {
        return true
    }
    
    func videoPlayer(_ player: NtvVideoPlayer, shouldDeactiveAudioSessionWithReason reason: String) -> Bool {
        return true
    }
}
