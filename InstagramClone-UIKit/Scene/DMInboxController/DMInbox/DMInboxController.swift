//
//  DMInboxController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit

class DMInboxController: BaseController {
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.dataSource = self
        t.delegate = self
        t.backgroundColor = UIColor(resource: .igBackground)
        t.separatorStyle = .none
        t.rowHeight = 72
        t.register(DMInboxCell.self, forCellReuseIdentifier: DMInboxCell.identifier)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private lazy var navTitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        return l
    }()
    
    private lazy var messageHeaderLabel: UILabel = {
        let l = UILabel()
        l.text = "Messages"
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var requestsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Requests", for: .normal)
        btn.setTitleColor(UIColor(resource: .igPurple), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "bubble.left.and.bubble.right"))
        icon.tintColor = .tertiaryLabel
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "No messages yet"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Start a conversation"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .tertiaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [icon, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        v.addSubview(stack)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 56),
            icon.heightAnchor.constraint(equalToConstant: 56),
            stack.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: v.centerYAnchor),
        ])
        return v
    }()
    
    
    private let viewModel = DMInboxViewModel()
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func configureUI() {
        
    }
    
    override func configureConstraints() {
        view.addSubview(messageHeaderLabel)
        view.addSubview(requestsButton)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            messageHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            messageHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            requestsButton.centerYAnchor.constraint(equalTo: messageHeaderLabel.centerYAnchor),
            requestsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: messageHeaderLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: messageHeaderLabel.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = navTitleLabel
        
        let composeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(composeTapped)
        )
        
        composeButton.tintColor = UIColor(resource: .igText)
        navigationItem.rightBarButtonItem = composeButton
    }
    
    @objc private func composeTapped() {
        
    }
    
    
    override func configureViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            
            let isEmpty = self.viewModel.recentMessages.isEmpty
            self.tableView.isHidden = isEmpty
            self.emptyStateView.isHidden = !isEmpty
        }
        
        viewModel.onCurrentUserLoaded = { [weak self] user in
            self?.navTitleLabel.text = user.name
            
        }
        viewModel.fetchRecentMessages()
        viewModel.fetchCurrentUser()
    }
}

extension DMInboxController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DMInboxCell.identifier, for: indexPath) as? DMInboxCell else {
            return UITableViewCell()
        }
        cell.configure(message: viewModel.recentMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = viewModel.recentMessages[indexPath.row]
        coordinator?.goToChat(message: message)
    }
}
