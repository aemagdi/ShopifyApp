//
//  Connectivity.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/9/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    static let shared = Connectivity()
    
    private init(){}
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
