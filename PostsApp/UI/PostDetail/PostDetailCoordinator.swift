//
//  PostDetailCoordinator.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIWindow

protocol PostDetailCoordinatorDelegate: AnyObject {}

final class PostDetailCoordinator {
    let navigationController: UINavigationController
    let apiClient: APIClientProtocol
    let post: Post
    
    var postDetailViewController: PostDetailViewController!
    
    weak var delegate: PostDetailCoordinatorDelegate?
    
    init (
        navigationController: UINavigationController,
        apiClient: APIClientProtocol,
        post: Post
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
        self.post = post
    }
}

// MARK: - Coordinatable

extension PostDetailCoordinator: Coordinatable {
    func start() {
        postDetailViewController = makePostDetailViewController()
        navigationController.pushViewController(postDetailViewController, animated: true)
    }
    
    func makePostDetailViewController() -> PostDetailViewController {
        let viewModel = PostDetailViewModel(apiClient: apiClient, post: post)
        viewModel.coordinatorDelegate = self
        return PostDetailViewController(viewModel: viewModel)
    }
}

extension PostDetailCoordinator: PostDetailViewModelCoordinatorDelegate {
    func postDetailViewModelDidFinish(_ viewModel: PostDetailViewModelProtocol) {
        
    }
}

