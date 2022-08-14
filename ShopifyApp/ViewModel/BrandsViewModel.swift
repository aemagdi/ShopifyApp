//
//  BrandsViewModel.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class BrandsViewModel {
    var brandsUnFilteredArray: [SmartCollection]?
    
    var brandsArray: [SmartCollection]? {
        didSet {
            bindingData(brandsArray, nil)
        }
    }
    
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    
    let apiService: ApiService
    var bindingData: (([SmartCollection]?,Error?) -> Void) = {_, _ in }
    
    init(apiService: ApiService = NetworkManager()) {
        self.apiService = apiService
    }
    
    func fetchData() {
        apiService.fetchBrands { brands, error in
            if let brands = brands {
                self.brandsArray = brands
                self.brandsUnFilteredArray = brands
            }
            if let error = error {
                self.error = error
            }
        }
    }
    
    func search(searchInput: String) {
        if searchInput.isEmpty {
            brandsArray = brandsUnFilteredArray
        } else {
            brandsArray = brandsUnFilteredArray?.filter({ (smartCollection) -> Bool in
                return smartCollection.title.hasPrefix(searchInput.lowercased()) ||      smartCollection.title.hasPrefix(searchInput.uppercased()) || smartCollection.title.contains(searchInput.lowercased()) ||        smartCollection.title.contains(searchInput.uppercased())
            })
        }
    }
}
