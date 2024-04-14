//
//  LoginQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation

// MARK: 서버에 보내는 모델
struct LoginQuery: Encodable {
    let email: String
    let password: String
}

struct EmailQuery: Encodable {
    let email: String
}

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
    let birthDay: String
    let phoneNum: String
}
