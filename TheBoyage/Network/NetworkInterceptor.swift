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
        var request = urlRequest
        if let token = UserDefaults.standard.string(forKey: "AccessToken"), let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") {
            request.setValue(token, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            request.setValue(refreshToken, forHTTPHeaderField: HTTPHeader.refresh.rawValue)
            request.setValue(APIKey.sesacKey.rawValue, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
        }
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode, statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetryWithError(error))
        }
    }
    
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        LoginNetworkManager.refreshToken()
            .subscribe { event in
            switch event {
            case .success(let refreshToken):
                UserDefaults.standard.set(refreshToken.accessToken, forKey: "AccessToken")
                completion(true)
            case .failure:
                UserDefaults.standard.removeObject(forKey: "AccessToken")
                completion(false)
            }
        }
    }
}
