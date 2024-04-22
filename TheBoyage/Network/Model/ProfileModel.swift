//
//  ProfileModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation

struct ProfileModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
//    let follwers: [String: String]
    
    enum CodingKeys: CodingKey {
        case user_id
        case email
        case nick
        case phoneNum
        case birthDay
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum)
        self.birthDay = try container.decodeIfPresent(String.self, forKey: .birthDay)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
    }
}

// 받는거
struct EditProfileModel: Decodable {
    let user_id: String?
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let profileImage: String?
    //    let follwers: [String: String]
    let posts: [String]?
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case email
        case nick
        case phoneNum
        case birthDay
        case profileImage
        case posts
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum)
        self.birthDay = try container.decodeIfPresent(String.self, forKey: .birthDay)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.posts = try container.decodeIfPresent([String].self, forKey: .posts)
    }
}
