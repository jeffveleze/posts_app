//
//  PostsViewController.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import UIKit

final class PostsViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var postsTableView: UITableView! {
        didSet {
            postsTableView.delegate = self
            postsTableView.dataSource = self
            postsTableView.register(cellType: PostCell.self)
        }
    }
    
    @IBOutlet var deleteButton: UIButton!
    
    var viewModel: PostsViewModelProtocol!

    init(viewModel: PostsViewModelProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchPosts()
    }
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
}

// MARK: - PostsViewModelViewDelegate

extension PostsViewController: PostsViewModelViewDelegate {
    func postsViewModelShouldReloadPosts(_ viewModel: PostsViewModelProtocol) {
        postsTableView.reloadData()
    }
    
    func postsViewModel(_ viewModel: PostsViewModelProtocol, didThrow error: Error) {
        
    }
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCell = postsTableView.dequeueReusableCell(for: indexPath)

        if !viewModel.posts.isEmpty {
            let vm = viewModel.posts[indexPath.item]
            cell.accessoryType = .disclosureIndicator
            cell.viewModel = vm
        }

        return cell
    }
}

// MARK: - PostsViewModelViewDelegate

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectPostAt(index: indexPath.row)
    }
}
