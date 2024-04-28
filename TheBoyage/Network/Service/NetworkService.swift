//
//  NetworkService.swift
//  TheBoyage
//
//  Created by Madeline on 4/24/24.
//

import Alamofire
import Foundation
import RxSwift

// MARK: Alamofire Request 추상화
struct NetworkService {
    static func performRequest<T: Decodable>(route: URLRequestConvertible, responseType: T.Type, completion: @escaping (T) -> Void) -> Single<T> {
        return Single<T>.create { single in
            do {
                let urlRequest = try route.asURLRequest()
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: responseType) { response in
                        switch response.result {
                        case .success(let value):
                            completion(value)
                            single(.success(value))
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
