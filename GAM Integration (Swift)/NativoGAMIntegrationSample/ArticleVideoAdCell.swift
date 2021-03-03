//
//  ArticleVideoAdCell.swift
//  NativoGAMIntegrationSample
//

import UIKit
import NativoSDK

class ArticleVideoAdCell: UITableViewCell, NtvVideoAdInterface {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
