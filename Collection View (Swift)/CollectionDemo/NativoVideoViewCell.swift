//
//  NativoVideoViewCell.swift
//  CollectionDemo
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

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
        return false;
    }

}
