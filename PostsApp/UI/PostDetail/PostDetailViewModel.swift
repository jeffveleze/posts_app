//
//  PostDetailViewModel.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import PromiseKit

protocol PostDetailViewModelViewDelegate: AnyObject {
    func postDetailViewModel(_ viewModel: PostDetailViewModelProtocol, didThrow error: Error)
}

protocol PostDetailViewModelCoordinatorDelegate: AnyObject {
    func postDetailViewModelDidFinish(_ viewModel: PostDetailViewModelProtocol)
}

protocol PostDetailViewModelProtocol: AnyObject {
    var coordinatorDelegate: PostDetailViewModelCoordinatorDelegate? { get set }
    var viewDelegate: PostDetailViewModelViewDelegate? { get set }

    var apiClient: APIClientProtocol { get }
    var post: Post { get }

    init(apiClient: APIClientProtocol, post: Post)
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    weak var coordinatorDelegate: PostDetailViewModelCoordinatorDelegate?
    weak var viewDelegate: PostDetailViewModelViewDelegate?

    var apiClient: APIClientProtocol
    var post: Post

    init(apiClient: APIClientProtocol, post: Post) {
        self.apiClient = apiClient
        self.post = post
    }
    
    func fetchPosts() {
//        let q = DispatchQueue.global()

//        q.async {
//          firstly(execute: { () -> Promise<[Post]> in
//            self.apiClient.fetchPosts()
//          }).then(on: q, flags: nil) { (posts) -> Promise<[PostCellViewModel]> in
//            var vms: [PostCellViewModel] = posts.map {
//                PostCellViewModel(post: $0)
//            }
//
//            vms = Array(vms.prefix(through: self.maxPostsDisplayed - 1))
//
//            return .value(vms)
//          }.done { posts in
//            self.posts = posts
//
//            self.viewDelegate?.postsViewModelShouldReloadPosts(self)
//          }.catch { err in
//            self.viewDelegate?.postsViewModel(self, didThrow: err)
//          }
//        }
    }
}
