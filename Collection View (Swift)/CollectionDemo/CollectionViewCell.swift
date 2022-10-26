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
            self.contentView.backgroundColor = UIColor(red: 0.906, green: 0.941, blue: 1.000, alpha: 1.000)
            self.sponsoredContentLabel.isHidden = false
            setAlphaAll(view: contentView, val: 1.0)
        }
    }
    
    func shouldPrependAuthorByline() -> Bool {
        return false;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAlphaAll(view: contentView, val: 0.88)
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
    
    func setAlphaAll(view : UIView, val : CGFloat) {
        view.subviews.forEach { subView in
            subView.alpha = val
            setAlphaAll(view: subView, val: val)
        }
    }
}
