//
//  Customer.swift
//  ShopifyApp
//
//  Created by Mina Ezzat on 7/2/22.
//  Copyright © 2022 Mina Ezzat. All rights reserved.
//

import Foundation

struct NewCustomer: Codable {
    let customer: Customer
}

struct LoginResponse: Codable {
    let customers: [Customer]
}

struct Customer: Codable {
    var first_name, email, tags: String?
    var id: Int?
    var addresses: [Address]?
}

struct Address: Codable {
    var id : Int?
    var customer_id : Int?
    var address1, city: String?
    var country: String?
    var phone : String?
}

struct NewAddress : Codable{
    var customer_address : Address?
}

struct CustomerAddress: Codable {
    var addresses: [Address]?
}

struct Addresses: Codable {
    var addresses: Address
}

struct PutAddress: Codable {
    let customer: CustomerAddress?
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
