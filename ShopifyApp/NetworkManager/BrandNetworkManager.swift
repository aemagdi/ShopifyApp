//
//  BrandNetworkManager.swift
//  ShopifyApp
//
//  Created by Abdelrahman Magdy on 05/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

//import Foundation
//
//class BrandsNetworkManager: BrandsApiService {
//    func fetchBrands(endPoint: String, completion: @escaping (([SmartCollection]?, Error?) -> Void)) {
//        // fetching data
//        if let  url = URL(string: UrlServices(endPoint: endPoint).url) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                print ("The response is \(response) The error is \(error) and the data is \(data)")
//                if let data = data {
//                    print("data is here")
//                    guard let decodedData : Brands = try? convertFromJson(data: data) else{ return}
//                    completion(decodedData.smartCollections,nil)
//                }
//                if let error = error {
//                   completion(nil, error)
//                }
//            }.resume()
//        }
//
//    }
//    }
//
//
