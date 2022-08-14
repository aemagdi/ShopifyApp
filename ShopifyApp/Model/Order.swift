//
//  Order.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 15/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct FinalOrderItem : Codable{
    var variant_id : Int?
    var quantity:Int?
    var name:String?
    var price:String?
    var title:String?
    
}

struct FinalOrder : Codable{
    var id:Int?
    var customer:Customer?
    var line_items:[FinalOrderItem]?
    var created_at:String?
    var financial_status: String = "paid"
    var current_total_price:String?
    var total_line_items_price:String?
    var total_price_usd:String?
    var contact_email:String?
    
}

struct FinalOrderToAPI : Codable{
    var order : FinalOrder
}

struct FinalOrdersFromAPI : Codable {
    var orders : [FinalOrder]
}
