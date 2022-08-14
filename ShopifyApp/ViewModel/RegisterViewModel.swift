//
//  RegisterViewModel.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class RegisterViewModel{
    
    let networkManager: ApiService?
    
    init(networkManager: ApiService) {
        self.networkManager = networkManager
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String, confirmPassword: String) -> Bool{
        return !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    func ValdiateCustomerInfomation(firstName: String, email: String, password: String, confirmPassword: String, compeltion: @escaping (String?) ->Void){
        
        if firstName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            compeltion("ErrorAllInfoIsNotFound")
            return
        }
        
        if !isValidEmail(email) {
            compeltion("ErrorEmail")
            return
        }
        
        if !isValidPassword(password: password, confirmPassword: confirmPassword) {
            compeltion("ErrorPassword")
            return
        }
    }
    
    func createNewCustomer(newCustomer: NewCustomer, completion:@escaping (Data?, HTTPURLResponse? , Error?)->()){
        networkManager?.register(newCustomer: newCustomer) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            let customer = json["customer"] as? Dictionary<String,Any>
            self.saveCustomerDataToUserDefaults(customer: customer)
            completion(data, response as? HTTPURLResponse, nil)
            
        }
    }
    
    func saveCustomerDataToUserDefaults(customer: Dictionary<String,Any>?) {
        
        let customerID = customer?["id"] as? Int ?? 0
        let customerFirstName = customer?["first_name"] as? String ?? ""
        let customerEmail = customer?["email"] as? String ?? ""
        
        UserDefaultsManager.shared.setUserID(customerID: customerID)
        UserDefaultsManager.shared.setUserName(userName: customerFirstName)
        UserDefaultsManager.shared.setUserEmail(userEmail: customerEmail)
        UserDefaultsManager.shared.setUserStatus(userIsLogged: true)
    }
    
}
