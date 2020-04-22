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
    func postsViewModel(_ viewModel: PostsViewModelProtocol, didDeletePostAt index: Int)
    func postsViewModelShouldShowNotFoundContentMessage(_ viewModel: PostsViewModelProtocol)
    func postsViewModelShouldStartLoader(_ viewModel: PostsViewModelProtocol)
    func postsViewModelShouldFinishLoader(_ viewModel: PostsViewModelProtocol)
}

protocol PostsViewModelCoordinatorDelegate: AnyObject {
    func postsViewModelDidFinish(_ viewModel: PostsViewModelProtocol)
    func postsViewModelDidSelect(postVm: PostCellViewModel, user: User)
}

protocol PostsViewModelProtocol: AnyObject {
    var coordinatorDelegate: PostsViewModelCoordinatorDelegate? { get set }
    var viewDelegate: PostsViewModelViewDelegate? { get set }

    var apiClient: APIClientProtocol { get }
    var postVms: [PostCellViewModel] { get }
    var visiblePostVms: [PostCellViewModel] { get }

    init(apiClient: APIClientProtocol)
    
    func makeTitleText() -> String
    func makeDeleteText() -> String
    func fetchPosts()
    func didSelectPostAt(index: Int)
    func didMarkAsFavorite(postVm: PostCellViewModel)
    func deletePostAt(index: Int)
    func deleteAllPosts()
    func didChangeDisplayedPosts()
    func loadPostsVMsLocally()
}

final class PostsViewModel: PostsViewModelProtocol {
    weak var coordinatorDelegate: PostsViewModelCoordinatorDelegate?
    weak var viewDelegate: PostsViewModelViewDelegate?

    var apiClient: APIClientProtocol
    var postVms: [PostCellViewModel] = []
    var visiblePostVms: [PostCellViewModel] = []
    var users: [User] = []
    
    private var areFavoritesPostsDisplayed: Bool = false
    private let initialPostsUnread = 20
    private let postsKey = "posts_key"

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func makeTitleText() -> String {
        return "Posts"
    }
    
    func makeDeleteText() -> String {
        return "Delete All"
    }
    
    func fetchPosts() {
        // Do a previous cleaning before fetching
        postVms.removeAll()
        
        viewDelegate?.postsViewModelShouldStartLoader(self)
        
        let q = DispatchQueue.global()

        q.async {
          firstly(execute: { () -> Promise<[Post]> in
            self.apiClient.fetchPosts()
          }).then(on: q, flags: nil) { (posts) -> Promise<[PostCellViewModel]> in
            
            // Build table cell view models
            let vms: [PostCellViewModel] = posts.enumerated().map { (index, item) in
                let vm = PostCellViewModel(post: item)
                vm.isUnread = index < self.initialPostsUnread
                return vm
            }
            
            return .value(vms)
          }.then { vms -> Promise<([PostCellViewModel], [User])> in
            self.apiClient.fetchUsers().map { (vms, $0) }
          }.done { result in
            let (postVms, users) = result
            
            self.postVms = postVms
            self.users = users
            
            self.performVmsUpdates()
            self.viewDelegate?.postsViewModelShouldReloadPosts(self)
          }.ensure {
            self.viewDelegate?.postsViewModelShouldFinishLoader(self)
          }.catch { err in
            
            // Load posts cached locally in case request failed
            self.loadPostsVMsLocally()
            
            if !self.visiblePostVms.isEmpty {
                self.viewDelegate?.postsViewModelShouldReloadPosts(self)
            }
          }
        }
    }
    
    func didSelectPostAt(index: Int) {
        // Mark as read the post
        postVms[index].isUnread = false
        
        performVmsUpdates()
        
        let postVm = visiblePostVms[index]
        
        if let user = getUserBy(id: postVm.post.userId) {
            // Go to details screen
            coordinatorDelegate?.postsViewModelDidSelect(postVm: postVm, user: user)
        } else {
            viewDelegate?.postsViewModelShouldShowNotFoundContentMessage(self)
        }
    }
    
    func didMarkAsFavorite(postVm: PostCellViewModel) {
        if let index = postVms.firstIndex(where: { $0.post.id == postVm.post.id }) {
            postVms[index] = postVm
            
            performVmsUpdates()
        }
    }
    
    func deletePostAt(index: Int) {
        let postVm = visiblePostVms[index]
        postVms.removeAll(where: { $0.post.id == postVm.post.id })
        
        performVmsUpdates()

        viewDelegate?.postsViewModel(self, didDeletePostAt: index)
    }
    
    func deleteAllPosts() {
        postVms.removeAll()
        
        performVmsUpdates()
        
        self.viewDelegate?.postsViewModelShouldReloadPosts(self)
    }
    
    func didChangeDisplayedPosts() {
        areFavoritesPostsDisplayed.toggle()
        
        performVmsUpdates()
        
        viewDelegate?.postsViewModelShouldReloadPosts(self)
    }
    
    func loadPostsVMsLocally() {
        if let savedPosts = UserDefaults.standard.object(forKey: postsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedPosts = try? decoder.decode(PostsGroupCellViewModels.self, from: savedPosts) {
                self.postVms = loadedPosts.postVms
                self.makeVisiblePosts()
            }
        }
    }
}

// MARK: - PostsViewModel

private extension PostsViewModel {
    func performVmsUpdates() {
        makeVisiblePosts()
        save(postVms: postVms)
    }
    
    func makeVisiblePosts() {
        visiblePostVms = areFavoritesPostsDisplayed ? postVms.filter { $0.isFavorite } : postVms
    }
    
    func getUserBy(id: Int) -> User? {
        return users.first(where: { $0.id == id })
    }
    
    func save(postVms: [PostCellViewModel]) {
        let postsGroupVms = PostsGroupCellViewModels(postVms: postVms)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(postsGroupVms) {
            UserDefaults.standard.set(encoded, forKey: postsKey)
        }
    }
}

