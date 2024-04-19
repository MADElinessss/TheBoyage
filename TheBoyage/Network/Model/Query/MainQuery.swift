//
//  ManagerQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Foundation

// 유저별 작성한 포스트 조회(운영자가 올린 포스트)
struct ManagerQuery: Encodable {
    let limit: String // 7개로 호출할 것
    let product_id: String
}
