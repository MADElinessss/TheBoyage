//
//  NetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Alamofire
import Foundation
import RxSwift


struct NetworkManager {
    // MARK: 로그인
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            print("success!\(loginModel)")
                            single(.success(loginModel))//성공하면 받는 데이터: at, rt
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
    
    // MARK: 이메일 유효성 검사
    static func emailValidation(query: EmailQuery) -> Single<EmailValidationModel> {
        return Single<EmailValidationModel>.create { single in
            do {
                let urlRequest = try Router.emailValidate(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .responseDecodable(of: EmailValidationModel.self) { response in
                        switch response.result {
                        case .success(let success):
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
