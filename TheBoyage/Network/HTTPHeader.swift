//
//  HTTPHeader.swift
//  TheBoyage
//
//  Created by Madeline on 4/11/24.
//

import Foundation

enum HTTPHeader: String {
    case authorization = "Authorization"
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
    case json = "application/json"
    case multipart = "multipart/form-data"
}
