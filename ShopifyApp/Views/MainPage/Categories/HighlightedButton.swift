//
//  HighlightedButton.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 13/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import UIKit

class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            print("didSet")
            isHighlighted == false
          backgroundColor = isHighlighted ? .clear : .purple
            isHighlighted == true

//          backgroundColor = backgroundColor  == UIColor.clear ? UIColor.purple : UIColor.red
        }
        willSet{
            print("willSet")
            backgroundColor = backgroundColor  == UIColor.clear ? UIColor.clear : UIColor.clear
        }
    }
}
