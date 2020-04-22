//
//  PostsGroupCellViewModels.swift
//  PostsApp
//
//  Created by Jefferson Velez on 23/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

struct PostsGroupCellViewModels: Codable {
    var postVms: [PostCellViewModel]
    
    enum CodingKeys: String, CodingKey {
        case postVms = "postVms"
    }
}
