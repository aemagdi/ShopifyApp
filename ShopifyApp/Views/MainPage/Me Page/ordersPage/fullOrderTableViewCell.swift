//
//  fullOrderTableViewCell.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 16/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class fullOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderCreatedAt: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
