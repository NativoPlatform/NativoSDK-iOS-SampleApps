//
//  CollectionViewCell.swift
//  CollectionDemo
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class CollectionViewCell: UICollectionViewCell, NtvAdInterface, NtvCollectionViewCellMaxWidthDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var sponsoredContentLabel: UILabel!
    

    func displaySponsoredIndicators(_ isSponsored: Bool) {
        if isSponsored {
            self.contentView.backgroundColor = UIColor.init(red: 0.9, green: 0.98, blue: 0.98, alpha: 1.0)
            self.sponsoredContentLabel.isHidden = false
        } else {
            self.contentView.backgroundColor = UIColor.white
            self.sponsoredContentLabel.isHidden = true
        }
    }
    
    func shouldPrependAuthorByline() -> Bool {
        return false;
    }
    
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
    
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint!
    func setMaxWidth(_ maxWidth: CGFloat) {
        if self.maxWidthConstraint == nil {
            self.maxWidthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: maxWidth)
            self.maxWidthConstraint.priority = UILayoutPriority(rawValue: 999);
        }
        self.maxWidthConstraint.constant = maxWidth
        self.maxWidthConstraint.isActive = true
    }
}
