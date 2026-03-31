//
//  FeedController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit

class FeedController: BaseController {
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.dataSource = self
        t.delegate = self
        t.backgroundColor = UIColor(resource: .igBackground)
        t.separatorStyle = .none
        t.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let li = UIActivityIndicatorView(style: .medium)
        li.hidesWhenStopped = true
        li.translatesAutoresizingMaskIntoConstraints = false
        return li
    }()
    
    private let viewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        title = "Instagram"
    }
    
    override func configureConstraints() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func configureViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            let alert = AlertBuilder()
                .setTitle("Hata")
                .setMessage(error.userFriendlyMessage)
                .setPrimaryButton("Tamam")
                .build()
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            self?.tableView.isHidden = isLoading
        }
        
        viewModel.fetchPosts()
    }
}

extension FeedController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        let post = viewModel.posts[indexPath.row]
        let user = viewModel.users[post.ownerUID]
        cell.configure(post: post, user: user)
        return cell
    }
}
