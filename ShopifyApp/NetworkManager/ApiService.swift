//
//  ApiService.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

protocol ApiService {
    func register(newCustomer: NewCustomer, completion:@escaping (Data?, URLResponse?, Error?)->())
    func getCustomers(email: String, complition: @escaping ([Customer]?, Error?)->Void)
    func getProduct(endPoint: String, complition: @escaping (Product?, Error?)->Void)
    func fetchBrands(completion: @escaping (([SmartCollection]?, Error?) -> Void))
    func fetchProducts(endPoint: String, completion: @escaping (([Product]?, Error?) -> Void))
    func fetchOrders(endPoint: String, completion: @escaping (([FinalOrder]?, Error?) -> Void))
}
