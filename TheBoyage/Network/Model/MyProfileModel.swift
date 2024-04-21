//
//  MyProfileModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/21/24.
//

import Foundation

struct MyProfileModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [User]?
    let following: [User]?
    let posts: [String]?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case phoneNum
        case birthDay
        case profileImage
        case followers
        case following
        case posts
    }
}

struct User: Decodable {
    let userId: String
    let nick: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
}
