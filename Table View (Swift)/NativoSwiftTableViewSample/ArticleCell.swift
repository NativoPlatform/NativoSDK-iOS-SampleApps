//
//  ArticleCell.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import UIKit
import NativoSDK

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var adImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setAlphaAll(view: contentView, val: 0.88)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAlphaAll(view : UIView, val : CGFloat) {
        view.subviews.forEach { subView in
            subView.alpha = val
            setAlphaAll(view: subView, val: val)
        }
    }

}

