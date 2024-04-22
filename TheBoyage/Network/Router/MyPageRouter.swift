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
    case editProfile(query: EditProfileQuery)
}

extension MyPageRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .profile:
                .get
        case .myFeed(_):
                .get
        case .editProfile(_):
                .put
        }
    }
    
    var path: String {
        switch self {
        case .profile:
            return "v1/users/me/profile"
        case .myFeed(let id):
            return "v1/posts/users/\(id)"
        case .editProfile(query: _):
            return "v1/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .profile:
            return [
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? ""
            ]
        case .myFeed(_):
            return [:]
        case .editProfile(query: _):
            return [
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue
            ]
        }
    }
    
    var parameter: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .profile:
            return nil
        case .myFeed(let id):
            return nil
        case .editProfile(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
        
    }
}
