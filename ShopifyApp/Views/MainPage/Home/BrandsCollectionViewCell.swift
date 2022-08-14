//
//  BrandsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 04/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import UIKit
import Alamofire

class BrandsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandLogo: UIImageView!
    
    @IBOutlet weak var brandName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        brandLogo.layer.borderColor = UIColor.lightGray.cgColor
        brandLogo.layer.borderWidth = 2
        brandLogo.layer.cornerRadius = 12
    }


}


