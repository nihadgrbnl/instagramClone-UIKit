//
//  CommentController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import UIKit

class CommentController: BaseController {
    
    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.dataSource = self
        t.backgroundColor = UIColor(resource: .igBackground)
        t.separatorStyle = .none
        t.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        t.keyboardDismissMode = .interactive
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    private lazy var inputContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(resource: .igBackground)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add a comment..."
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = UIColor(resource: .igText)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Post", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.tintColor = UIColor(resource: .igPurple)
        btn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(resource: .igBorder)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let viewModel : CommentViewModel
    
    init(postID: String) {
        self.viewModel = CommentViewModel(postID: postID)
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        title = "Comments"
    }
    
    override func configureConstraints() {
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(separatorView)
        inputContainerView.addSubview(commentTextField)
        inputContainerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            separatorView.topAnchor.constraint(equalTo: inputContainerView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            commentTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
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
        
        viewModel.fetchComments()
    }
    
    @objc private func sendTapped() {
        guard let text = commentTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.postComment(text: text)
        commentTextField.text = ""
        view.endEditing(true)
    }
}

extension CommentController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.configure(comment: viewModel.comments[indexPath.row])
        return cell
    }
}
