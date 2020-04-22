//
//  User.swift
//  PostsApp
//
//  Created by Jefferson Velez on 22/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var website: String
    
    // Keys from API response
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case website = "website"
    }
}
