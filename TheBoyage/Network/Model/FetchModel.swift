//
//  FetchModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/19/24.
//

import Foundation

struct FetchModel: Decodable {
    var data: [Posts]
}

struct Posts: Decodable {
    var post_id: String
    var product_id: String?
    var title: String?
    var content: String?
    var content1: String?
    var createdAt: String
    var creator: Creator
    var files: [String]
    var likes: [String]
    var likes2: [String]
    var hashTags: [String]
    var comments: [CommentModel]
}

struct CommentModel: Decodable {
    let comment_id: String
    let content: String
    let createdAt: String
    let creator: Creator
}

struct Creator: Decodable {
    var user_id: String
    var nick: String
    var profileImage: String?
}
