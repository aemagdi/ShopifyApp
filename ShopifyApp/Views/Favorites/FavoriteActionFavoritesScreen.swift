//
//  FavoriteActionFavoritesScreen.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/9/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

protocol FavoriteActionFavoritesScreen {
    func deleteFavourite(appDelegate: AppDelegate, product: Product) -> Void
}
