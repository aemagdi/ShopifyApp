//
//  DatabaseService.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/6/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

protocol DatabaseService{
    func getShoppingCartProductList(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Product]?, Error?)->Void)
    func getItemFromShoppingCartProductList(appDelegate: AppDelegate, product: Product, complition: @escaping ([Product]?, Error?)->Void)
    func addProduct(appDelegate: AppDelegate, product: Product)
    func updateProductFromList(appDelegate: AppDelegate, product: Product)
    func deleteProduct(appDelegate: AppDelegate, product: Product)
    func emptyCart(appDelegate: AppDelegate, userId: Int)
    func addFavourite(appDelegate: AppDelegate, product: Product)
    func getFavourites(appDelegate: AppDelegate, userId: Int, complition: @escaping ([Product]?, Error?)->Void)
    func getItemFromFavourites(appDelegate: AppDelegate, product: Product, complition: @escaping ([Product]?, Error?)->Void)
    func deleteFavourite(appDelegate: AppDelegate, product: Product)
}

