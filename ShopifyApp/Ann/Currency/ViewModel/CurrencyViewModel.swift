//
//  CurrencyViewModel.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 13/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import Combine

protocol CurrencyViewModelProtocol {
    func fetchData()
}

class CurrencyViewModel: CurrencyViewModelProtocol {
    
    var currencyData = [CurrencyModel]()
    
    func fetchData() {
        currencyData.append(contentsOf: [
            CurrencyModel(currency: "EG"),
            CurrencyModel(currency: "USD")
        ])
    }
    
}
