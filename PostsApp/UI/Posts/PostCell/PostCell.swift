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
            setImage()
            titleText.text = viewModel.makeTitleText()
            
            viewModel.viewDelegate = self
        }
    }
    
    func setImage() {
        if let image = viewModel.makeImage() {
            statusImage.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reset()
    }
    
    private func reset() {
        statusImage.image = nil
        titleText.text = nil
    }
}

// MARK: - PostCellViewModelDelegate

extension PostCell: PostCellViewModelViewDelegate {
    func postCellViewModelShouldUpdateImage(_ viewModel: PostCellViewModelProtocol) {
        setImage()
    }
}
