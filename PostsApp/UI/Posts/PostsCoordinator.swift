//
//  PostsCoordinator.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import Foundation
import UIKit.UIWindow

enum PostsCoordinatorFlow {
    case postDetailCoordinator
}

protocol Coordinatable {
    func start()
}

final class PostsCoordinator {
    let window: UIWindow
    let apiClient: APIClientProtocol
    
    var flow: [PostsCoordinatorFlow: Coordinatable] = [:]
    var postsViewController: PostsViewController!
    var navigationController: UINavigationController!
    
    init(window: UIWindow, apiClient: APIClientProtocol) {
        self.window = window
        self.apiClient = apiClient
    }
}

// MARK: - Coordinatable

extension PostsCoordinator: Coordinatable {
    func start() {
        postsViewController = makePostsViewController()
        navigationController = UINavigationController(rootViewController: postsViewController)
        window.rootViewController = navigationController
    }
    
    func makePostsViewController() -> PostsViewController {
        let viewModel = PostsViewModel(apiClient: apiClient)
        viewModel.coordinatorDelegate = self
        return PostsViewController(viewModel: viewModel)
    }
}

// MARK: - PostsViewModelCoordinatorDelegate

extension PostsCoordinator: PostsViewModelCoordinatorDelegate {
    func postsViewModelDidFinish(_ viewModel: PostsViewModelProtocol) {}

    func postsViewModelDidSelect(post: Post) {
        let coordinator = PostDetailCoordinator(
            navigationController: navigationController,
            apiClient: apiClient,
            post: post
        )

        coordinator.delegate = self
        coordinator.start()

        flow[.postDetailCoordinator] = coordinator
    }
}

// MARK: - PostDetailCoordinatorDelegate

extension PostsCoordinator: PostDetailCoordinatorDelegate {

}
