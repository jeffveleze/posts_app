//
//  CommentCell.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Reusable
import UIKit

final class CommentCell: UITableViewCell, NibReusable {
    
    @IBOutlet var commentText: UILabel!

    var viewModel: CommentCellViewModelProtocol! {
        didSet {
            commentText.text = viewModel.makeTitleText()
        }
    }
}
