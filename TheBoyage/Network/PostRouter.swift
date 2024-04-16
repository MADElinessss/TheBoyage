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
}

extension PostRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .imageUpload(let query):
                .post
        }
    }
    
    var path: String {
        switch self {
        case .imageUpload(let query):
            return "v1posts/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .imageUpload(let query):
            return [
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        }
    }
    
    var parameter: String? {
        switch self {
        case .imageUpload(let query):
            return nil
        }
    }
    
    var queryItem: [URLQueryItem]? {
        switch self {
        case .imageUpload(let query):
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .imageUpload(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
}
