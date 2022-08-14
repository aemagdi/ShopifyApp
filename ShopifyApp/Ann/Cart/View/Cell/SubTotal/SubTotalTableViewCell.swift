//
//  SubTotalTableViewCell.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 04/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class SubTotalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalPriceValueLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
