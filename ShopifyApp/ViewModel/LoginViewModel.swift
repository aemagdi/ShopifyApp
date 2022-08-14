//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class LoginViewModel {
    let networkManager: ApiService?
       
    init(networkManager: ApiService) {
        self.networkManager = networkManager
    }
    
    func Login(email: String, password: String, completion: @escaping (Customer?)-> Void){
        networkManager?.getCustomers(email: email){ customers, error in
            guard error == nil else {return}
            guard let customers = customers else {return}
            var currentCustomer: Customer?
            
            for customer in customers {
                if customer.email == email && customer.tags == password {
                    currentCustomer = customer
                }
            }
            
            if currentCustomer != nil{
                self.saveCustomerDataToUserDefaults(customer: currentCustomer!)
                completion(currentCustomer)
            } else {
                completion(nil)
            }
        }
    }
    
    func saveCustomerDataToUserDefaults(customer: Customer){
        guard let customerID = customer.id else {return}
        guard let userFirstName = customer.first_name else {return}
        guard let userEmail = customer.email  else {return}

        UserDefaultsManager.shared.setUserID(customerID: customerID)
        UserDefaultsManager.shared.setUserName(userName: userFirstName)
        UserDefaultsManager.shared.setUserEmail(userEmail: userEmail)
    }
    
}
