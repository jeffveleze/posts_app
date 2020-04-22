//
//  PostCellViewModel.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol PostCellViewModelViewDelegate: AnyObject {
    func postCellViewModelShouldUpdateImage(_ viewModel: PostCellViewModelProtocol)
}

protocol PostCellViewModelProtocol: AnyObject {
    var post: Post { get }
    var viewDelegate: PostCellViewModelViewDelegate? { get set }
    
    var isUnread: Bool { get set }
    var isFavorite: Bool { get set }

    init(post: Post)
    
    func makeTitleText() -> String
    func makeImage() -> UIImage?
}

final class PostCellViewModel: PostCellViewModelProtocol, Codable {
    let post: Post
    
    var isUnread: Bool = false
    var isFavorite: Bool = false
    
    var viewDelegate: PostCellViewModelViewDelegate?
    
    init(post: Post) {
        self.post = post
    }
    
    func makeTitleText() -> String {
        return post.title.capitalized
    }
    
    func makeImage() -> UIImage? {
        if isFavorite {
            return UIImage(imageLiteralResourceName: "Favorite")
        }
        
        if isUnread {
            return UIImage(imageLiteralResourceName: "Bluedot")
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case post = "post"
        case isUnread = "isUnread"
        case isFavorite = "isFavorite"
    }
}

