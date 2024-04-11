//
//  NetworkModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation

// MARK: 서버에서 받는 모델
struct RefreshToken: Decodable {
    let accessToken: String
}
