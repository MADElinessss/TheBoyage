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
        case .myFeed(let id):
                .get
        case .editProfile(let query):
                .put
        }
    }
    
    var path: String {
        switch self {
        case .profile:
            return "v1/users/me/profile"
        case .myFeed(let id):
            return "v1/posts/users/\(id)"
        case .editProfile(query: let query):
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
        case .myFeed(let id):
            return [:]
        case .editProfile(query: let query):
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
        return nil
    }
}
