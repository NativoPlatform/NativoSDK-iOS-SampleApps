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
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.leftAnchor.constraint(equalTo: leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: rightAnchor),
            self.contentView.topAnchor.constraint(equalTo: topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func displaySponsoredIndicators(_ isSponsored: Bool) {
        if isSponsored {
            self.contentView.backgroundColor = UIColor.init(red: 0.9, green: 0.98, blue: 0.98, alpha: 1.0)
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
    }

}
