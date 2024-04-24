//
//  LoginModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation

// MARK: 서버에서 받는 모델
struct LoginModel: Decodable {
    let accessToken: String
    let refreshToken: String
    let user_id: String
}

struct EmailValidationModel: Decodable {
    let message: String
}

struct SignUpModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}

struct WithdrawModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
}
