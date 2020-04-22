//
//  Posts.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
    // Keys from API response
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case title = "title"
        case body = "body"
    }
}
