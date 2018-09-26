//
//  IssueTableViewCell.swift
//  SigTuple
//
//  Created by Coffeebeans on 25/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import UIKit
import SDWebImage

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var prNumberLabel: UILabel!
    @IBOutlet weak var patchUrlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ model:GitHubModel?) {
        userNameLabel.text = model?.user?.login ?? ""
        titleLabel.text = model?.title ?? ""
        prNumberLabel.text = "\(model?.number ?? 0)"
        patchUrlLabel.text = model?.pull_request?.patch_url ?? ""
        userImageView.sd_setImage(with: URL(string: model?.user?.avatar_url ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        userImageView.sd_setShowActivityIndicatorView(true)
        userImageView.sd_setIndicatorStyle(.gray)
    }
    
    
}
