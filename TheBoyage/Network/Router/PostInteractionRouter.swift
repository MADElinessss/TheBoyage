//
//  PostInteractionRouter.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Alamofire
import Foundation

enum PostInteractionRouter {
    case comment(id: String, query: CommentQuery)
    case like(id: String, query: LikeQuery)
}

extension PostInteractionRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .comment(_,_), .like(_,_):
                .post
        }
    }
    
    var path: String {
        switch self {
        case .comment(let id, _):
            return "v1/posts/\(id)/comments"
        case .like(let id, _):
            return "v1/posts/\(id)/like"
        }
    }
    
    var header: [String : String] {
        return [
            HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
            HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
        ]
    }
    
    var parameter: String? {
        return nil
    }
    
    var queryItem: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .comment(_, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                let jsonData = try encoder.encode(query)
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonData
            } catch {
                return nil
            }
        case .like(_, let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        }
    }
    
    
}
