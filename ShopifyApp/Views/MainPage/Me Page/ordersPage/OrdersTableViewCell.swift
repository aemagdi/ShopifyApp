//
//  OrdersTableViewCell.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 15/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var ordersPrice: UILabel!
    
    @IBOutlet weak var orderCreatedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
