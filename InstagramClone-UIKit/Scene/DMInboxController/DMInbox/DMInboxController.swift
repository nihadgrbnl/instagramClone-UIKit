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
        
        NSLayoutConstraint.activate([
            messageHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            messageHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            requestsButton.centerYAnchor.constraint(equalTo: messageHeaderLabel.centerYAnchor),
            requestsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: messageHeaderLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "nihadgrbnl"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(resource: .igText)
        navigationItem.titleView = titleLabel
        
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
            self?.tableView.reloadData()
        }
        viewModel.fetchRecentMessages()
    }
}

extension DMInboxController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DMInboxCell.identifier, for: indexPath) as! DMInboxCell
        cell.configure(message: viewModel.recentMessages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = viewModel.recentMessages[indexPath.row]
        coordinator?.goToChat(message: message)
    }
}
