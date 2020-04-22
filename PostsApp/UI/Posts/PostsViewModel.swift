//
//  PostsViewModel.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import PromiseKit

protocol PostsViewModelViewDelegate: AnyObject {
    func postsViewModel(_ viewModel: PostsViewModelProtocol, didThrow error: Error)
    func postsViewModelShouldReloadPosts(_ viewModel: PostsViewModelProtocol)
}

protocol PostsViewModelCoordinatorDelegate: AnyObject {
    func postsViewModelDidFinish(_ viewModel: PostsViewModelProtocol)
    func postsViewModelDidSelect(post: Post)
}

protocol PostsViewModelProtocol: AnyObject {
    var coordinatorDelegate: PostsViewModelCoordinatorDelegate? { get set }
    var viewDelegate: PostsViewModelViewDelegate? { get set }

    var apiClient: APIClientProtocol { get }
    var posts: [PostCellViewModel] { get }

    init(apiClient: APIClientProtocol)
    
    func fetchPosts()
    func didSelectPostAt(index: Int)
}

final class PostsViewModel: PostsViewModelProtocol {
    weak var coordinatorDelegate: PostsViewModelCoordinatorDelegate?
    weak var viewDelegate: PostsViewModelViewDelegate?

    var apiClient: APIClientProtocol
    var posts: [PostCellViewModel] = []
    
    let maxPostsDisplayed = 20

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchPosts() {
        let q = DispatchQueue.global()

        q.async {
          firstly(execute: { () -> Promise<[Post]> in
            self.apiClient.fetchPosts()
          }).then(on: q, flags: nil) { (posts) -> Promise<[PostCellViewModel]> in
            var vms: [PostCellViewModel] = posts.map {
                PostCellViewModel(post: $0)
            }
            
            vms = Array(vms.prefix(through: self.maxPostsDisplayed - 1))
            
            return .value(vms)
          }.done { posts in
            self.posts = posts
            
            self.viewDelegate?.postsViewModelShouldReloadPosts(self)
          }.catch { err in
            self.viewDelegate?.postsViewModel(self, didThrow: err)
          }
        }
    }
    
    func didSelectPostAt(index: Int) {
        let post = posts[index].post
        coordinatorDelegate?.postsViewModelDidSelect(post: post)
        coordinatorDelegate?.postsViewModelDidFinish(self)
    }
}

