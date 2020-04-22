//
//  CommentCellViewModel.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol CommentCellViewModelViewDelegate: AnyObject {}

protocol CommentCellViewModelProtocol: AnyObject {
    var comment: Comment { get }
    var viewDelegate: CommentCellViewModelViewDelegate? { get set }

    init(comment: Comment)
    
    func makeTitleText() -> String
}

final class CommentCellViewModel: CommentCellViewModelProtocol {
    let comment: Comment
    
    var viewDelegate: CommentCellViewModelViewDelegate?
        
    init(comment: Comment) {
        self.comment = comment
    }
    
    func makeTitleText() -> String {
        return comment.body.capitalized
    }
}
