//
//  PostDetailViewController.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var viewModel: PostDetailViewModelProtocol!

    init(viewModel: PostDetailViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
        self.viewModel.viewDelegate = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - PostDetailViewModelViewDelegate

extension PostDetailViewController: PostDetailViewModelViewDelegate {
    func postDetailViewModel(_ viewModel: PostDetailViewModelProtocol, didThrow error: Error) {
        
    }
}
