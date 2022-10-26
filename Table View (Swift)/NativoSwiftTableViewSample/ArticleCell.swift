//
//  ArticleCell.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleCell: UITableViewCell, NtvAdInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var sponsoredBackground: UIView!
    @IBOutlet weak var sponsoredLabel: UILabel!
    
    
    // Use this to switch UI between Nativo ad cell and Article cell
    func displaySponsoredIndicators(_ isSponsored: Bool) {
        if isSponsored {
            self.titleLabel.alpha = 1.0;
            self.sponsoredLabel.isHidden = false
            self.contentView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.000)
            setAlphaAll(val: 1.0)
        } else {
            self.titleLabel.alpha = 0.8;
            self.sponsoredLabel.isHidden = true
            self.contentView.backgroundColor = UIColor.white
            setAlphaAll(val: 0.9)
        }
    }
    
    func setAlphaAll(val : CGFloat) {
        self.subviews.forEach { view in
            view.alpha = val
            view.subviews.forEach { subview in
                subview.alpha = val
            }
        }
    }
 
    func shouldPrependAuthorByline() -> Bool {
        return true
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

