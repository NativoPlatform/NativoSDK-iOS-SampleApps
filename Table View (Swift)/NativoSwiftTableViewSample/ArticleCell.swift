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
    @IBOutlet weak var sponsoredLabel: UILabel!
    @IBOutlet weak var sponsoredIndicator: UIImageView!
    
    
    // Use this to switch UI between Nativo ad cell and Article cell
    func displaySponsoredIndicators(_ isSponsored: Bool) {
        if isSponsored {
            self.titleLabel.alpha = 1.0;
            self.sponsoredLabel.isHidden = false
            self.sponsoredIndicator.isHidden = false
            self.contentView.backgroundColor = UIColor.init(red: 230/255.0, green: 235/255.0, blue: 242/255.0, alpha: 1)
        } else {
            self.titleLabel.alpha = 0.7;
            self.sponsoredLabel.isHidden = true
            self.sponsoredIndicator.isHidden = true
            self.contentView.backgroundColor = UIColor.white
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

