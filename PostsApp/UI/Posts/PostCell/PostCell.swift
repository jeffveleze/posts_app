//
//  PostCell.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Reusable
import UIKit

final class PostCell: UITableViewCell, NibReusable {
    
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var titleText: UILabel!
        
    var viewModel: PostCellViewModelProtocol! {
        didSet {
            statusImage.image = viewModel.makeImage()
            titleText.text = viewModel.makeTitleText()
            
            viewModel.viewDelegate = self
        }
    }
}

// MARK: - PostCellViewModelDelegate

extension PostCell: PostCellViewModelViewDelegate {
    
}
