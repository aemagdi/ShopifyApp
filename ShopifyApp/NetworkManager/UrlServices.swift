//
//  UrlServices.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct UrlServices {
    var endPoint: String = ""
    var url: String  {
       return "https://7d67dd63dc90e18fce08d1f7746e9f41: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@ios-q3-mansoura.myshopify.com/admin/api/2022-01/\(endPoint)"
    }
}

enum EndPoint: String {
    case customers = "customers.json"
    case smartCollections = "smart_collections.json"
}

