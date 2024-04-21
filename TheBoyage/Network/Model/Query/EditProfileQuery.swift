//
//  EditProfileQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/22/24.
//

import Foundation

struct EditProfileQuery: Encodable {
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profile: Data?
}
