//
//  Router.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Alamofire
import Foundation

enum Router {
    case login(query: LoginQuery)
}

extension Router: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login(let query):
                .post
        }
    }
    
    var path: String {
        switch self {
        case .login(let query):
            return "users/login"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login(let query):
            return [
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameter: String? {
        switch self {
        case .login(let query):
            return nil
        }
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .login(let query):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
}
