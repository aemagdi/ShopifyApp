//
//  CategoryViewModel.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 10/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class CollectsViewModel {
    var collectsArray: [Collect]? {
        didSet {
            bindingData(collectsArray,nil)
        }
    }
    var error: Error? {
        didSet {
            bindingData(nil, error)
        }
    }
    let apiService: ApiService
    var bindingData: (([Collect]?,Error?) -> Void) = {_, _ in }
    init(apiService: ApiService = NetworkManager()) {
        self.apiService = apiService
    }
    func fetchCollects(endPoint: String) {
        apiService.fetchCollects(endPoint: endPoint) { collects, error in
            if let collects = collects {
                self.collectsArray = collects
            }
            if let error = error {
                self.error = error
            }
        }
    }
    
    
}
