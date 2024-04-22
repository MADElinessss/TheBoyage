//
//  EditProfileQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/22/24.
//

import Foundation
// 서버에 보내는거
struct EditProfileQuery: Encodable {
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
}
