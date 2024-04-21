//
//  Router.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Alamofire
import Foundation

// TODO: Router도 종류별로 분리해서 쓰기
enum LoginRouter {
    case login(query: LoginQuery)
    case emailValidate(query: EmailQuery)
    case signUp(query: SignUpQuery)
    case refresh
    case withdraw
}

extension LoginRouter: TargetType {
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login(_):
                .post
        case .emailValidate(query: _):
                .post
        case .signUp(query: _):
                .post
        case .refresh:
                .get
        case .withdraw:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .login(_):
            return "v1/users/login"
        case .emailValidate(query: _):
            return "v1/validation/email"
        case .signUp(query: _):
            return "v1/users/join"
        case .refresh:
            return "v1/auth/refresh"
        case .withdraw:
            return "v1/users/withdraw"
        }
    }

    var header: [String : String] {
        switch self {
        case .login(_):
            return [
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        case .emailValidate(query: _):
            return [
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        case .signUp(query: _):
            return [
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
            ]
        case .refresh:
            return [
                HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                HTTPHeader.refresh.rawValue : UserDefaults.standard.string(forKey: "RefreshToken") ?? ""
            ]
        case .withdraw:
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
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .emailValidate(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .signUp(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(query)
        case .refresh:
            return nil
        case .withdraw:
            return nil
        }
    }
}
