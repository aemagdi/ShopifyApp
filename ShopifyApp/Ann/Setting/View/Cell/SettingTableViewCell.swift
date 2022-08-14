//
//  SettingTableViewCell.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageNameOutlet: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
