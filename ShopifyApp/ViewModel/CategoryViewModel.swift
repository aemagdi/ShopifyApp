//
//  CategoryViewModel.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 12/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation


class CategoriesViewModel {
    var selectedCategory: Category = .men
    var allProductsArray = [Product]()
    var filteredArray = [Product]()
    var menCategory = [Product]()
    var womenCategory = [Product]()
    var kidCategory = [Product]()
    var saleCategory = [Product]()
    var shownArray: [Product]? {
        didSet {
            bindingData(shownArray,nil)
        }
    }
    
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    
    let apiService: ApiService
    let databaseService : DatabaseService
    var bindingData: (([Product]?,Error?) -> Void) = {_, _ in }
    
    init(apiService: ApiService = NetworkManager(), databaseService: DatabaseService = DatabaseManager()) {
        self.apiService = apiService
        self.databaseService = databaseService
    }
    
    func fetchProducts(endPoint: String) {
        apiService.fetchProducts(endPoint: endPoint) { products, error in
            if let products = products {
                self.allProductsArray = products
                self.filteredArray = products
                self.mainCategoryProducts(mainCategory: ", men", category: .main)
            }
            
            if let error = error {
                self.error = error
            }
        }
    }
    
    func mainCategoryProducts(mainCategory: String, category: CategoryPriority) {
        switch category {
            case .main:
                filteredArray = allProductsArray.filter({ (product) -> Bool in
                    return product.tags!.contains(mainCategory)
                })
                shownArray = filteredArray
            case .sub:
                shownArray = filteredArray.filter({ (product) -> Bool in
                    return product.productType!.contains(mainCategory)
                })
        }
    }
    
    func selectedMenCategory() {
        selectedCategory = .men
        mainCategoryProducts(mainCategory: ", men", category: .main)
    }
    
    func selectedWomenCategory() {
        selectedCategory = .women
        mainCategoryProducts(mainCategory: ", women", category: .main)
    }
    
    func selectedKidsCategory() {
        selectedCategory = .kids
        mainCategoryProducts(mainCategory: ", kid", category: .main)
    }
    
    func selectedSaleCategory() {
        selectedCategory = .sale
        mainCategoryProducts(mainCategory: ", sale", category: .main)
    }
    
    func selectedShoesCategory() {
        mainCategoryProducts(mainCategory: "SHOES", category: .sub)
    }
    
    func selectedShirtsCategory() {
        mainCategoryProducts(mainCategory: "T-SHIRTS", category: .sub)
    }
    
    func selectedAccessoriesCategory() {
        mainCategoryProducts(mainCategory: "ACCESSORIES", category: .sub)
    }
    
    func getProductsInFavourites(appDelegate: AppDelegate, product: inout Product) -> Bool {
        var isFavourite: Bool = false
        if !UserDefaultsManager.shared.getUserStatus() {
            return isFavourite
        }
       
        var productsArray = [Product]()
        product.userID = UserDefaultsManager.shared.getUserID()!
        databaseService.getItemFromFavourites(appDelegate: appDelegate, product: product, complition: { (products, error) in
            if let products = products {
                productsArray = products
            }
        })

        for item in productsArray {
            if item.id == product.id {
                isFavourite = true
            }
        }
        return isFavourite
    }
    
    func addFavourite(appDelegate: AppDelegate, product: Product){
         databaseService.addFavourite(appDelegate: appDelegate, product: product)
    }
    
    func deleteFavourite(appDelegate: AppDelegate, product: Product){
         databaseService.deleteFavourite(appDelegate: appDelegate, product: product)
    }
    
    func search(searchInput: String) {
        if searchInput.isEmpty {
            switch selectedCategory {
                case .men:
                    selectedMenCategory()
                case .women:
                    selectedWomenCategory()
                case .kids:
                    selectedKidsCategory()
                case .sale:
                    selectedSaleCategory()
            }
        } else {
            shownArray = shownArray!.filter({ (product) -> Bool in
                return product.title.hasPrefix(searchInput.lowercased()) ||          product.title.hasPrefix(searchInput.uppercased()) ||
                    product.title.contains(searchInput.lowercased()) ||   product.title.contains(searchInput.uppercased())
            })
        }
    }
    
}

enum Category: String{
    case men
    case women
    case kids
    case sale
}

enum SubCategory: String {
    case SHOES
    case SHIRTS = "T-SHIRTS"
    case ACCESSORIES
}

enum CategoryPriority: String{
    case main
    case sub
}
