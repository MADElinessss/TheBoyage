//
//  ImageUploadQuery.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Foundation

struct ImageUploadQuery: Encodable {
    let files: Data
}

struct PostQuery: Encodable {
    let title: String
    let content: String
    let content1: String
    let product_id: String
    let files: [String]
}
