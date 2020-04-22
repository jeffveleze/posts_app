//
//  PostsViewController.swift
//  PostsApp
//
//  Created by Jefferson Velez on 21/04/20.
//  Copyright © 2020 Jefferson Velez. All rights reserved.
//

import PKHUD
import UIKit

final class PostsViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl! {
        didSet {
            let greenColor = UIColor.makeBackgroundsGreen()
            segmentedControl.backgroundColor = greenColor
            
            segmentedControl.setTitleTextAttributes(
                [.foregroundColor: UIColor.white],
                for: .normal)
            
            segmentedControl.setTitleTextAttributes(
                [.foregroundColor: greenColor],
                for: .selected
            )
        }
    }
    
    @IBOutlet var postsTableView: UITableView! {
        didSet {
            postsTableView.delegate = self
            postsTableView.dataSource = self
            postsTableView.register(cellType: PostCell.self)
        }
    }
    
    @IBOutlet var deleteButton: UIButton! {
        didSet {
            deleteButton.setTitle(viewModel.makeDeleteText(), for: .normal)
        }
    }
    
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
        
        setupHeader()
        
        viewModel.fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postsTableView.reloadData()
    }
    
    private func setupHeader() {
        navigationItem.title = viewModel.makeTitleText()
        navigationItem.rightBarButtonItem = makeRefreshButton()
        navigationController?.navigationBar.barTintColor = UIColor.makeBackgroundsGreen()
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    private func makeRefreshButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self, action:
            #selector(refreshPostsTapped(_:))
        )
        
        button.tintColor = .white
        
        return button
    }
    
    func didMarkAsFavorite(postVm: PostCellViewModel) {
        viewModel.didMarkAsFavorite(postVm: postVm)
    }
    
    @objc func refreshPostsTapped(_: UIBarButtonItem) {
        viewModel.fetchPosts()
    }

    @IBAction func segmentedControlTapped(_ sender: Any) {
        viewModel.didChangeDisplayedPosts()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.deleteAllPosts()
    }
}

// MARK: - PostsViewModelViewDelegate

extension PostsViewController: PostsViewModelViewDelegate {
    func postsViewModelShouldStartLoader(_ viewModel: PostsViewModelProtocol) {
        HUD.show(.progress)
        HUD.hide(afterDelay: 15.0)
    }
    
    func postsViewModelShouldFinishLoader(_ viewModel: PostsViewModelProtocol) {
        HUD.hide()
    }
    
    func postsViewModelShouldShowNotFoundContentMessage(_ viewModel: PostsViewModelProtocol) {
        let alert = UIAlertController(
            title: "No existent content",
            message: "Coming soon 🙄",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func postsViewModel(_ viewModel: PostsViewModelProtocol, didDeletePostAt index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        postsTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func postsViewModelShouldReloadPosts(_ viewModel: PostsViewModelProtocol) {
        postsTableView.reloadData()
    }
    
    func postsViewModel(_ viewModel: PostsViewModelProtocol, didThrow error: Error) {}
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visiblePostVms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostCell = postsTableView.dequeueReusableCell(for: indexPath)

        if !viewModel.visiblePostVms.isEmpty {
            let vm = viewModel.visiblePostVms[indexPath.item]
            cell.accessoryType = .disclosureIndicator
            cell.viewModel = vm
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deletePostAt(index: indexPath.row)
        }
    }
}

// MARK: - PostsViewModelViewDelegate

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectPostAt(index: indexPath.row)
    }
}
