//
//  NetworkInterceptor.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Alamofire
import Foundation

class NetworkInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("--------NetworkInterceptor adapt------------")
        var request = urlRequest
        if let token = UserDefaults.standard.string(forKey: "AccessToken"), let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") {
            request.setValue(token, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            request.setValue(refreshToken, forHTTPHeaderField: HTTPHeader.refresh.rawValue)
            request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
        }
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("--------NetworkInterceptor retry------------")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        if statusCode == 419 || statusCode == 403 {
            refreshToken { isSuccess in
                isSuccess ? completion(.retry) : completion(.doNotRetryWithError(error))
            }
        } else {
            completion(.doNotRetry)
        }
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        LoginNetworkManager.refreshToken()
            .subscribe { event in
            switch event {
            case .success(let refreshToken):
                UserDefaults.standard.set(refreshToken.accessToken, forKey: "AccessToken")
                print("인터셉터 - 로그인 refresh 함수 하고나서 성공")
                completion(true)
            case .failure:
                UserDefaults.standard.removeObject(forKey: "AccessToken")
                completion(false)
            }
        }
    }
}
