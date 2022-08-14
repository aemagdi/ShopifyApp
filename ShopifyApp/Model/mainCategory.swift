//
//  mainCategory.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 10/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

// MARK: - MainCategory
struct MainCategory: Decodable {
    let customcollections: [CustomCollection]
    
    enum CodingKeys: String, CodingKey {
        case customcollections = "custom_collections"
    }
}
// MARK: - CustomCollection
struct CustomCollection : Decodable {
    let id: Int?
    let handle, title: String?
    let updatedAt: Date?
    let bodyHTML: String?
    let publishedAt: Date?
    let sortOrder: String?
    
    let publishedScope, adminGraphqlAPIID: String?
    let image: CategoryImage?
}

// MARK: - Image
struct CategoryImage : Decodable {
    let createdAt: Date?
     
    let width, height: Int?
    let src: String?
}
