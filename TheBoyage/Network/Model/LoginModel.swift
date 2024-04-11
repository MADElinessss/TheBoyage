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
}

