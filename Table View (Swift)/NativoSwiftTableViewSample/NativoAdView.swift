//
//  NativoAdView.swift
//  NativoSwiftTableViewSample
//
//  Copyright © 2023 Nativo. All rights reserved.
//

import Foundation
import NativoSDK

class NativoAdView: UIView, NtvAdInterface {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var isiContentView: UIView!
    
    func shouldPrependAuthorByline() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
