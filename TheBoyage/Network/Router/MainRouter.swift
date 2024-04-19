//
//  MainRouter.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Alamofire
import Foundation

enum MainRouter {
    case managerPost(id: String, query: ManagerQuery)
}

extension MainRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .managerPost(_,_):
                .get
        }
    }
    
    var path: String {
        switch self {
        case .managerPost(id: let id, query: _):
            return "v1/posts/users/\(id.self)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .managerPost(_,_):
            return [
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameter: String? {
        switch self {
        case .managerPost(let id, let query):
            return "limit=\(query.limit)&product_id=\(query.product_id)"
        }
    }
    
    var queryItem: [URLQueryItem]? {
        return nil
//        switch self {
//        case .managerPost(let id, let query):
//            return [
//                "limit" : query.limit,
//                "product_id" : query.product_id
//            ]
//        }
    }
    
    var body: Data? {
        return nil
    }
    
    
}
