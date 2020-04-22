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
    func postDetailViewModelShouldReloadComments(_ viewModel: PostDetailViewModelProtocol)
    func postDetailViewModelShouldStartLoader(_ viewModel: PostDetailViewModelProtocol)
    func postDetailViewModelShouldFinishLoader(_ viewModel: PostDetailViewModelProtocol)
}

protocol PostDetailViewModelCoordinatorDelegate: AnyObject {
    func postDetailViewModel(_ viewModel: PostDetailViewModelProtocol, didMarkAsFavorite postVm: PostCellViewModel)
    func postDetailViewModelDidFinish(_ viewModel: PostDetailViewModelProtocol)
}

protocol PostDetailViewModelProtocol: AnyObject {
    var coordinatorDelegate: PostDetailViewModelCoordinatorDelegate? { get set }
    var viewDelegate: PostDetailViewModelViewDelegate? { get set }

    var apiClient: APIClientProtocol { get }
    var postVm: PostCellViewModel { get }
    var user: User { get }
    var comments: [CommentCellViewModel] { get set }

    init(
        apiClient: APIClientProtocol,
        postVm: PostCellViewModel,
        user: User
    )
    
    func makeTitleText() -> String
    func makeNameText() -> String
    func makeEmailText() -> String
    func makePhoneText() -> String
    func makeWebsiteText() -> String
    func makePostDescriptionText() -> String
    func makeCommentsSectionTitle() -> String
    func makeFavoritesImageName() -> String
    func fetchComments()
    func didFavoritePost()
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    weak var coordinatorDelegate: PostDetailViewModelCoordinatorDelegate?
    weak var viewDelegate: PostDetailViewModelViewDelegate?

    let apiClient: APIClientProtocol
    let postVm: PostCellViewModel
    let user: User
    
    var comments: [CommentCellViewModel] = []

    init(
        apiClient: APIClientProtocol,
        postVm: PostCellViewModel,
        user: User
    ) {
        self.apiClient = apiClient
        self.postVm = postVm
        self.user = user
    }
    
    func makeTitleText() -> String {
        return "Posts"
    }
    
    func makeNameText() -> String {
        return user.name.capitalized
    }
    
    func makeEmailText() -> String {
        return user.email
    }
    
    func makePhoneText() -> String {
        return user.phone
    }
    
    func makeWebsiteText() -> String {
        return user.website
    }
    
    func makePostDescriptionText() -> String {
        return postVm.post.body.capitalized
    }
    
    func makeCommentsSectionTitle() -> String {
        return "Comments"
    }
    
    func makeFavoritesImageName() -> String {
        return postVm.isFavorite ? "Favorite" : "NonFavorite"
    }
    
    func fetchComments() {
        viewDelegate?.postDetailViewModelShouldStartLoader(self)
        
        let q = DispatchQueue.global()

        q.async {
          firstly(execute: { () -> Promise<[Comment]> in
            self.apiClient.fetchComments(postID: self.postVm.post.id)
          }).then(on: q, flags: nil) { (comments) -> Promise<[CommentCellViewModel]> in
            
            // Build table cell view models
            let vms: [CommentCellViewModel] = comments.map {
                CommentCellViewModel(comment: $0)
            }

            return .value(vms)
          }.done { comments in
            self.comments = comments
            
            self.viewDelegate?.postDetailViewModelShouldReloadComments(self)
          }.ensure {
            self.viewDelegate?.postDetailViewModelShouldFinishLoader(self)
          }.catch { err in
            self.viewDelegate?.postDetailViewModel(self, didThrow: err)
          }
        }
    }
    
    func didFavoritePost() {
        postVm.isFavorite.toggle()
    
        coordinatorDelegate?.postDetailViewModel(self, didMarkAsFavorite: postVm)
    }
}
