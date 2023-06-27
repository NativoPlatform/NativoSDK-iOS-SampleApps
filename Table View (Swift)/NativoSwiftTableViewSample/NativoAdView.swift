//
//  NativoAdView.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2022 Nativo. All rights reserved.
//

import Foundation
import NativoSDK

class NativoAdView: UIView, NtvAdInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var adImageView: UIImageView!
     
    func shouldPrependAuthorByline() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
