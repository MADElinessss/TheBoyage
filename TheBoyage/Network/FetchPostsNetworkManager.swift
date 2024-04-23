//
//  FetchPostsNetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Alamofire
import Foundation
import RxSwift

struct FetchPostsNetworkManager {
    
    static let session = Session(interceptor: NetworkInterceptor())
    
    
    static func fetchManagers(id: String, query: ManagerQuery) -> Single<FetchModel> {
        return Single<FetchModel>.create { single in
            do {
                let url = URL(string: APIKey.baseURL.rawValue + "/v1/posts/users/\(id)?limit=7&product_id=boyage_general")!
                
                let headers: HTTPHeaders = [
                    HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
                ]
                AF.request(url, method: .get, headers: headers)
                    .responseDecodable(of: FetchModel.self) { response in
                        print("🐣 = ", response.response?.statusCode)
                        if let statusCode = response.response?.statusCode, statusCode == 419 {
                            single(.failure(URLError(.cancelled)))
                            // 419 상태 코드를 URLError.cancelled로 매핑
                        } else {
                            switch response.result {
                            case .success(let success):
                                single(.success(success))
                            case .failure(let failure):
                                single(.failure(failure))
                            }
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // MARK: interceptor + token refresh
    static func fetchPostWithRetry(query: FetchPostQuery) -> Single<FetchModel> {
        return Single<FetchModel>.create { single in
            do {
                let urlRequest = try MainRouter.fetchPost(query: query).asURLRequest()
                session.request(urlRequest)
                    .responseDecodable(of: FetchModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(success))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }

}
