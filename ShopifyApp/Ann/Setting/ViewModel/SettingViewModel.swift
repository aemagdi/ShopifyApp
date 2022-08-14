//
//  SettingViewModel.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 08/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import Combine

protocol SettingViewModelProtocol {
    func fetchData()
}

class SettingViewModel: SettingViewModelProtocol {
    
    var settingData = [SettingModel]()
    
    func fetchData() {
        settingData.append(contentsOf: [
            SettingModel(imageName: "location.circle.fill", title: "Address"),
            SettingModel(imageName: "coloncurrencysign.circle.fill", title: "Currency"),
            SettingModel(imageName: "exclamationmark.shield.fill", title: "About us"),
            SettingModel(imageName: "exclamationmark.triangle.fill", title: "Terms and Conditions"),
            SettingModel(imageName: "rectangle.portrait.and.arrow.right.fill", title: "Log out")
        ])
    }
    
}
