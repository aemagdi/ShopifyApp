//
//  OrdersViewModel.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 15/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//


import Foundation

class OrdersViewModel {
    
    var ordersArray = [FinalOrder] (){
        didSet {
            bindingData(ordersArray,nil)
        }
    }
    
    
    var Error: Error? {
        didSet {
           bindingData(nil, Error)
        }
    }
    
    let apiService: ApiService
    var bindingData: (([FinalOrder]?,Error?) -> Void) = {_, _ in }
        
    init(apiService: ApiService = NetworkManager()) {
        self.apiService = apiService
    }

    func fetchOrders(endPoint: String) {
        apiService.fetchOrders(endPoint: endPoint) { orders, error in
            if let orders = orders {
                self.ordersArray = orders
            }
            
            if let error = error {
                self.Error = error
            }
        }
    }
   
}


