//
//  Constants.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/7/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

enum Storyboards: String {
    case productInfo = "ProductInfo"
    case register = "Register"
    case login = "Login"
    case favourites = "Favorites"
    case splashScreen = "SplashScreen"
    case reviews = "Reviews"
    case home = "MainPage"
}

enum StoryboardID: String {
    case productInfo = "MProductInfoVC"
    case register = "RegisterVC"
    case login = "LoginVC"
    case favourites = "FavoritesVC"
    case splashScreen = "SplashScreenVC"
    case reviews = "ReviewsVC"
    case home = "MainPageID"
    case tabScreen = "TabScreenID"

}

enum NibFiles: String {
    case productInfoCell = "ProductInfoCollectionViewCell"
    case reviewCell = "ReviewTableViewCell"
    case ordersCell = "ordersCellID"
}

enum IdentifierCell: String {
    case productInfoCell = "ProductInfoCell"
    case reviewCell = "ReviewCell"
    case  ordersTableViewCell = "OrdersTableViewCell"
}

