//
//  PostCellViewModel.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol PostCellViewModelViewDelegate: AnyObject {}

protocol PostCellViewModelProtocol: AnyObject {
    var post: Post { get }
    var viewDelegate: PostCellViewModelViewDelegate? { get set }

    init(post: Post)
    
    func makeTitleText() -> String
    func makeImage() -> UIImage
}

final class PostCellViewModel: PostCellViewModelProtocol {
    var post: Post
    
    var viewDelegate: PostCellViewModelViewDelegate?
    
    init(post: Post) {
        self.post = post
    }
    
    func makeTitleText() -> String {
        return post.title.capitalized
    }
    
    func makeImage() -> UIImage {
        return UIImage()
    }
}

