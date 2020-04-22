//
//  PostDetailViewController.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import PKHUD
import UIKit

final class PostDetailViewController: UIViewController {
    @IBOutlet var descriptionTitle: UILabel!
    
    @IBOutlet var descriptionText: UILabel! {
        didSet {
            descriptionText.text = viewModel.makePostDescriptionText()
        }
    }
    
    @IBOutlet var userTitle: UILabel!
    
    @IBOutlet var userName: UILabel! {
        didSet {
            userName.text = viewModel.makeNameText()
        }
    }
    
    @IBOutlet var email: UILabel! {
        didSet {
            email.text = viewModel.makeEmailText()
        }
    }
    
    @IBOutlet var phone: UILabel! {
        didSet {
            phone.text = viewModel.makePhoneText()
        }
    }
    
    @IBOutlet var website: UILabel! {
        didSet {
            website.text = viewModel.makeWebsiteText()
        }
    }
    
    @IBOutlet var commentsTableView: UITableView! {
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.register(cellType: CommentCell.self)
        }
    }
    
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
        
        setupHeader()
        viewModel.fetchComments()
    }
    
    private func setupHeader() {
        navigationItem.title = viewModel.makeTitleText()
        navigationItem.rightBarButtonItem = makeFavoritesButton()
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func makeFavoritesButton() -> UIBarButtonItem {
        let imageName = viewModel.makeFavoritesImageName()
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)

        let barItem = UIBarButtonItem(customView: button)
        let currWidth = barItem.customView?.widthAnchor.constraint(equalToConstant: 30)
        let currHeight = barItem.customView?.heightAnchor.constraint(equalToConstant: 30)
        
        currWidth?.isActive = true
        currHeight?.isActive = true
                
        return barItem
    }
    
    @objc func favoriteButtonTapped(_: UIBarButtonItem) {
        viewModel.didFavoritePost()
        
        setupHeader()
    }
}

// MARK: - PostDetailViewModelViewDelegate

extension PostDetailViewController: PostDetailViewModelViewDelegate {
    func postDetailViewModelShouldStartLoader(_ viewModel: PostDetailViewModelProtocol) {
        HUD.show(.progress)
    }
    
    func postDetailViewModelShouldFinishLoader(_ viewModel: PostDetailViewModelProtocol) {
        HUD.hide()
    }
    
    func postDetailViewModelShouldReloadComments(_ viewModel: PostDetailViewModelProtocol) {
        commentsTableView.reloadData()
    }
    
    func postDetailViewModel(_ viewModel: PostDetailViewModelProtocol, didThrow error: Error) {
        let alert = UIAlertController(
            title: "No existent comments",
            message: "Some posts seem to have failing comments response",
            preferredStyle: .alert
        )
      
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
              
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension PostDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentCell = commentsTableView.dequeueReusableCell(for: indexPath)

        if !viewModel.comments.isEmpty {
            let vm = viewModel.comments[indexPath.item]
            cell.viewModel = vm
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.makeCommentsSectionTitle()
    }
}
