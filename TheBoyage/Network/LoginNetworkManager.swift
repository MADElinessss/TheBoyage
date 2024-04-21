//
//  NetworkManager.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Alamofire
import Foundation
import RxSwift

struct LoginNetworkManager {
    // MARK: 로그인
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try LoginRouter.login(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            print("success!\(loginModel)")
                            UserDefaults.standard.set(loginModel.accessToken, forKey: "AccessToken")
                            UserDefaults.standard.set(loginModel.refreshToken, forKey: "RefreshToken")
                            
                            single(.success(loginModel)) //성공하면 받는 데이터: at, rt
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
    
    static func refreshToken() -> Single<RefreshToken> {
        return Single<RefreshToken>.create { single in
            do {
                let urlRequest = try LoginRouter.refresh.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: RefreshToken.self) { response in
                        switch response.result {
                        case .success(let success):
                            UserDefaults.standard.set(success.accessToken, forKey: "AccessToken")
                            single(.success(success))
                        case .failure(let error):
                            // 응답코드 418 -> 로그인하세요
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    static func withdraw() -> Single<WithdrawModel> {
        return Single<WithdrawModel>.create { single in
            do {
                let urlRequest = try LoginRouter.withdraw.asURLRequest()
                AF.request(urlRequest)
                    .responseDecodable(of: WithdrawModel.self) { response in
                        print(response.response?.statusCode)
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
   
    
    // MARK: 이메일 유효성 검사
    static func emailValidation(query: EmailQuery) -> Single<EmailValidationModel> {
        return Single<EmailValidationModel>.create { single in
            do {
                let urlRequest = try LoginRouter.emailValidate(query: query).asURLRequest()
                
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
    
    // MARK: 회원 가입
    static func signUp(query: SignUpQuery) -> Single<SignUpModel> {
        return Single<SignUpModel>.create { single in
            do {
                let urlRequest = try LoginRouter.signUp(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .responseDecodable(of: SignUpModel.self) { response in
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
