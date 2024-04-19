//
//  FetchModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Foundation

struct FetchModel: Decodable {
    var postID: String?
    var product_id: String?
    var title: String?
    var content: String?
    var content1: String?
    var createdAt: Date?
    var creator: Creator?
    var files: [String]?
    var likes: [String]?
    var likes2: [String]?
    var hashTags: [String]?
    var comments: [String]?

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case product_id = "product_id"
        case title, content, content1
        case createdAt = "createdAt"
        case creator, files, likes, likes2, hashTags, comments
    }
}

struct Creator: Codable {
    var userID: String?
    var nick: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
    }
}
