//
//  Comment.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation

struct Comment: Codable, Identifiable {
    var id: Int
    var postId: Int
    var name: String
    var email: String
    var body: String
    
    // Keys from API response
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case postId = "postId"
        case name = "name"
        case email = "email"
        case body = "body"
    }
}
