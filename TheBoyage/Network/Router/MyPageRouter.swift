//
//  MyPageRouter.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Alamofire
import Foundation

enum MyPageRouter {
    case profile
    case myFeed(id: String)
}

extension MyPageRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .profile:
            return "v1/users/me/profile"
        case .myFeed(let id):
            return "v1/posts/users/\(id)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .profile:
            return [
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? ""
            ]
        case .myFeed(let id):
            return [:]
        }
    }
    
    var parameter: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
