//
//  PostInteractionQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/28/24.
//

import Foundation

struct CommentQuery: Encodable {
    let content: String
}

struct LikeQuery: Encodable {
    let like_status: Bool
}
