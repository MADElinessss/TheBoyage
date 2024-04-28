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
    
    private static func saveTokens(userId: String, accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(userId, forKey: "UserId")
        UserDefaults.standard.set(accessToken, forKey: "AccessToken")
        UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
    }
    
    static func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return NetworkService.performRequest(route: LoginRouter.login(query: query), responseType: LoginModel.self) { loginModel in
            saveTokens(userId: loginModel.user_id, accessToken: loginModel.accessToken, refreshToken: loginModel.refreshToken)
        }
    }
    
    static func refreshToken() -> Single<RefreshToken> {
        return NetworkService.performRequest(route: LoginRouter.refresh, responseType: RefreshToken.self) { refreshToken in
            UserDefaults.standard.set(refreshToken.accessToken, forKey: "AccessToken")
        }
    }
    
    static func withdraw() -> Single<WithdrawModel> {
        return NetworkService.performRequest(route: LoginRouter.withdraw, responseType: WithdrawModel.self) { _ in }
    }
    
    static func emailValidation(query: EmailQuery) -> Single<EmailValidationModel> {
        return NetworkService.performRequest(route: LoginRouter.emailValidate(query: query), responseType: EmailValidationModel.self) { _ in }
    }
    
    static func signUp(query: SignUpQuery) -> Single<SignUpModel> {
        return NetworkService.performRequest(route: LoginRouter.signUp(query: query), responseType: SignUpModel.self) { _ in }
    }
}
