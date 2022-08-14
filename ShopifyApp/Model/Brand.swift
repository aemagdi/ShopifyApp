//
//  Product.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 04/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct Brands: Codable {
    let smartCollections: [SmartCollection]
    enum CodingKeys: String, CodingKey
    { case smartCollections = "smart_collections" }
    
}

// MARK: - SmartCollection

struct SmartCollection: Codable {
    let id: Int
    let handle, title: String
    let image: Image?
    
}

struct Image: Codable {
//    let createdAt: Date
//    let alt: JSONNull?
//    let width, height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
//        case createdAt = "created_at"
        case src
//        alt, width, height,
    }
}
