//
//  AddressesModel.swift
//  ShopifyApp
//
//  Created by Ann mohammed on 12/07/2022.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation
import CoreData


// MARK :- OfflineStorage
@objc(Addresses)
public class AddressesModel: NSManagedObject {
    
    
    @NSManaged var addressId: Int64
    @NSManaged var phoneNumber: Int64
    @NSManaged var addressName: String
    @NSManaged var cityName: String
    @NSManaged var countryName: String
    
    
}
