//
//  CartItem.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 11/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import CoreData

// MARK :- OfflineStorage
@objc(CartItem)
public class CartItemModel: NSManagedObject {
    
    @NSManaged var itemID: Int64
    @NSManaged var itemImage: String
    @NSManaged var itemName: String
    @NSManaged var itemPrice: String
    @NSManaged var itemQuantity: Int64
    @NSManaged var userID: Int64
    
}
