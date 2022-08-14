//
//  UserDefaults.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

class UserDefaultsManager{
    
    static let shared = UserDefaultsManager()
    
    private init() {
        
    }
    
    func setUserID(customerID: Int?){
        UserDefaults.standard.set(customerID, forKey: "User_ID")
    }
    
    func getUserID()-> Int?{
        return UserDefaults.standard.integer(forKey: "User_ID")
    }
    
    func setUserName(userName: String?){
        UserDefaults.standard.set(userName, forKey: "User_Name")
    }
    
    func getUserName()-> String?{
        return UserDefaults.standard.string(forKey: "User_Name")
    }
    
    func setUserEmail(userEmail: String?){
        UserDefaults.standard.set(userEmail, forKey: "User_Email")
    }
    
    func getUserEmail()-> String?{
        return UserDefaults.standard.string(forKey: "User_Email")
    }
    
    func setUserStatus(userIsLogged: Bool){
        UserDefaults.standard.set(userIsLogged, forKey: "User_Status")
    }
    
    func getUserStatus()-> Bool{
        return UserDefaults.standard.bool(forKey: "User_Status")
    }
    
}
