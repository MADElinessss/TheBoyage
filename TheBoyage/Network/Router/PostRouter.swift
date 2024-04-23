//
//  PostRouter.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Alamofire
import Foundation

enum PostRouter {
    case imageUpload(query: ImageUploadQuery)
    case postContent(query: PostQuery)
}

extension PostRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .imageUpload(_):
                .post
        case .postContent(query: _):
                .post
        }
    }
    
    var path: String {
        switch self {
        case .imageUpload(_):
            return "v1/posts/files"
        case .postContent(query: _):
            return "v1/posts"
        
        }
    }
    
    var header: [String : String] {
        switch self {
        case .imageUpload(_):
            return [
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        case .postContent(query: _):
            return [
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameter: String? {
        switch self {
        case .imageUpload(_):
            return nil
        case .postContent(query: _):
            return nil
        }
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .imageUpload(_):
            return nil
        case .postContent(query: _):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .imageUpload(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .postContent(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
}
