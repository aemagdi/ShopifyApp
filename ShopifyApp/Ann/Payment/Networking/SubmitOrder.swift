//
//  SubmitOrder.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 12/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation


extension SubmitOrderNetworking{
    
    func SubmitOrder(order: OrderToAPI,completion: @escaping (Data?,URLResponse?,Error?)->Void){
        guard let url = URL(string: URLConstatnt.sumbmitOrder) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: order.asDictionary(), options: .prettyPrinted)
            print(try! order.asDictionary())
        }catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request) { (data,response,error) in
            completion(data, response, error)
        }.resume()
    }
}
class SubmitOrderNetworking{
    
    static var shared = SubmitOrderNetworking()
}
