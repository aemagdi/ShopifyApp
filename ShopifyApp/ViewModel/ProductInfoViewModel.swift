//
//  ProductInfoViewModel.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/6/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class ProductInfoViewModel {
    var product: Product? {
        didSet {
            bindingData(product, nil)
        }
    }

    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }

    let networkService: ApiService
    let databaseService: DatabaseService
    var bindingData: ((Product?,Error?) -> Void) = {_, _ in }

    init(networkService: ApiService = NetworkManager(), databaseService: DatabaseService = DatabaseManager()) {
        self.networkService = networkService
        self.databaseService = databaseService
    }

    func getProduct(endPoint: String) {
        networkService.getProduct(endPoint: endPoint) { product, error in

            if let product = product {
                self.product = product
            }

            if let error = error {
                self.error = error
            }
        }
    }
    
    func getProductsInShopingCart(appDelegate: AppDelegate, product: inout Product, complition: @escaping ()-> Void ) -> Bool {
        var isInShoppingCart: Bool = false
        if !UserDefaultsManager.shared.getUserStatus() {
            complition()
            return isInShoppingCart
        }
        
        product.userID = UserDefaultsManager.shared.getUserID()!
        var productsArray = [Product]()
        databaseService.getItemFromShoppingCartProductList(appDelegate: appDelegate, product: product) { (products, error) in
            if let products = products {
                productsArray = products
            }
        }
        
        for item in productsArray {
            if item.id == product.id {
                isInShoppingCart = true
            }
        }
        complition()
        return isInShoppingCart
    }
    
    func getProductsInFavourites(appDelegate: AppDelegate, product: inout Product, complition: @escaping ()-> Void) -> Bool {
        var isFavourite: Bool = false
        
        if !UserDefaultsManager.shared.getUserStatus() {
            complition()
            return isFavourite
        }
        
        product.userID = UserDefaultsManager.shared.getUserID()!
        var productsArray = [Product]()
        databaseService.getItemFromFavourites(appDelegate: appDelegate, product: product) { (products, error) in
            if let products = products {
                productsArray = products
            }
        }
        
        for item in productsArray {
            if item.id == product.id {
                isFavourite = true
            }
        }
        complition()
        return isFavourite
    }
    
    func addProductToCart(appDelegate: AppDelegate, product: Product) {
        databaseService.addProduct(appDelegate: appDelegate, product: product)
    }
    
    func removeProductFromCart(appDelegate: AppDelegate, product: Product) {
        databaseService.deleteProduct(appDelegate: appDelegate, product: product)
    }
    
    func addProductToFavourites(appDelegate: AppDelegate, product: Product) {
        databaseService.addFavourite(appDelegate: appDelegate, product: product)
    }
    
    func removeProductFromFavourites(appDelegate: AppDelegate, product: Product) {
        databaseService.deleteFavourite(appDelegate: appDelegate, product: product)
    }
}
