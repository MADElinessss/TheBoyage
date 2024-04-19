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
    static func fetchManagers(id: String, query: ManagerQuery) -> Single<FetchModel> {
        return Single<FetchModel>.create { single in
            do {
                // let urlRequest = try MainRouter.managerPost(id: id, query: query).asURLRequest()

                let url = URL(string: APIKey.baseURL.rawValue + "/v1/posts/users/\(id)?limit=1&product_id=boyage_general")!
                print(url)
                let parameters = [
                    "limit" : 1,
                    "product_id" : "boyage_general"
                ]
                let headers: HTTPHeaders = [
                    HTTPHeader.authorization.rawValue : UserDefaults.standard.string(forKey: "AccessToken") ?? "",
                    HTTPHeader.sesacKey.rawValue : APIKey.sesacKey.rawValue
                ]
                AF.request(url, method: .get, parameters: parameters, headers: headers)
                    .responseDecodable(of: FetchModel.self) { response in
                        print("🐣 manager Fetch = ", response.response?.statusCode)
                        switch response.result {
                        case .success(let success):
                            print("success = ", success)
                            single(.success(success))
                        case .failure(let failure):
                            single(.failure(failure))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
