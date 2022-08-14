//
//   TargetType.swift
//  NetworkLayerAlamofireWithCodable
//
//  Created by Ahmed on 11/7/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
import Alamofire

enum  HTTPMethod: String {
    
    case get    = "GET" // no needed to send param to server and get just or only data from server
    
    case post   = "POST" // needed to send param to server and get data from server
    
    case put    = "PUT"
    
    case delete = "DELETE"
    
}

enum Task {
    
    case requestPlain // .get
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding) // .post
    
}

protocol TargetType {
    
    var baseURL: String { get } // https:// ann.com/api/ 
    
    var path   : String { get } //login // register
    
    var method : HTTPMethod { get }
    
    var task   : Task { get }
    
    var headers : [String: String]? { get }
    
}


