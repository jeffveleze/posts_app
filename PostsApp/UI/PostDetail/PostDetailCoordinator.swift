//
//  PostDetailCoordinator.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIWindow

protocol PostDetailCoordinatorDelegate: AnyObject {
    func postDetailCoordinator(_ coordinator: PostDetailCoordinator, didMarkAsFavorite postVm: PostCellViewModel)
}

final class PostDetailCoordinator {
    let navigationController: UINavigationController
    let apiClient: APIClientProtocol
    let postVm: PostCellViewModel
    let user: User
    
    var postDetailViewController: PostDetailViewController!
    
    weak var delegate: PostDetailCoordinatorDelegate?
    
    init (
        navigationController: UINavigationController,
        apiClient: APIClientProtocol,
        postVm: PostCellViewModel,
        user: User
    ) {
        self.navigationController = navigationController
        self.apiClient = apiClient
        self.postVm = postVm
        self.user = user
    }
}

// MARK: - Coordinatable

extension PostDetailCoordinator: Coordinatable {
    func start() {
        postDetailViewController = makePostDetailViewController()
        navigationController.pushViewController(postDetailViewController, animated: true)
    }
    
    func makePostDetailViewController() -> PostDetailViewController {
        let viewModel = PostDetailViewModel(
            apiClient: apiClient,
            postVm: postVm,
            user: user
        )
        
        viewModel.coordinatorDelegate = self
        return PostDetailViewController(viewModel: viewModel)
    }
}

extension PostDetailCoordinator: PostDetailViewModelCoordinatorDelegate {
    func postDetailViewModel(_ viewModel: PostDetailViewModelProtocol, didMarkAsFavorite postVm: PostCellViewModel) {
        delegate?.postDetailCoordinator(self, didMarkAsFavorite: postVm)
    }
    
    func postDetailViewModelDidFinish(_ viewModel: PostDetailViewModelProtocol) {}
}

