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
    case fetchPost(query: FetchPostQuery)
}

extension MainRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .managerPost(_,_), .fetchPost(_):
                .get
        }
    }
    
    var path: String {
        switch self {
        case .managerPost(id: let id, query: _):
            return "v1/posts/users/\(id.self)"
        case .fetchPost(_):
            return "v1/posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .managerPost(_,_), .fetchPost(_):
            return [
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameter: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .managerPost(_, let query):
            return [URLQueryItem(name: "limit", value: query.limit),
                    URLQueryItem(name: "product_id", value: query.product_id)]
        case .fetchPost(query: let query):
            return [URLQueryItem(name: "limit", value: query.limit),
                    URLQueryItem(name: "product_id", value: query.product_id)]
        }
    }
    
    var body: Data? {
        return nil
    }
}
