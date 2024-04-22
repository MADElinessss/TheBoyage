//
//  PostModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Foundation

struct ImageUploadModel: Decodable {
    let files: [String]?
}

struct PostModel: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String?
    let content1: String?
    let files: [String]?
    let likes: [String]?
    let likes2: [String]?
    let hashTags: [String]?
    let comments: [String]?
}
