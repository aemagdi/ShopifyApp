//
//  CartProductTableViewCell.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 04/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageOutlet: UIImageView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var priceLabelOutlet: PaddingLabel!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var countLabelOutlet: UILabel!
    
    var MinusTapped: (() -> Void)?
    var plusTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        MinusTapped?()
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        plusTapped?()
    }
    
}
