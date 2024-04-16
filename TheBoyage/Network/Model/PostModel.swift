//
//  PostModel.swift
//  TheBoyage
//
//  Created by Madeline on 4/16/24.
//

import Foundation

struct PostModel: Decodable {
    let files: [String]?
    
    enum CodingKeys: CodingKey {
        case files
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.files = try container.decodeIfPresent([String].self, forKey: .files)
    }
}
