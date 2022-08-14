//
//  Collects.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 11/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Collects: Codable {
    let collects: [Collect]
}

// MARK: - Collect
struct Collect: Codable {
    let id, collectionID, productID: Int
//    let createdAt, updatedAt: Date
//    let position: Int
//    let sortValue: String

    enum CodingKeys: String, CodingKey {
        case id 
        case collectionID = "collection_id"
        case productID = "product_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case position
//        case sortValue = "sort_value"
    }
}

