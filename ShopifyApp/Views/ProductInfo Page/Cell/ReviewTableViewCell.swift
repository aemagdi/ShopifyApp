//
//  ReviewTableViewCell.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/12/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userRating: CosmosView!
    @IBOutlet weak var userReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.height / 2
    }

    func configureCell(user: Review) {
        let url = URL(string: user.image)
        userImage.kf.setImage(with: url)
        userRating.rating = user.rating
        userReview.text = user.review
    }
    
}
