//
//  ChatViewController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 17.03.26.
//

import UIKit

class ChatViewController: BaseController {
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(resource: .igBackground)
        cv.keyboardDismissMode = .interactive
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        cv.register(TextMessageCell.self, forCellWithReuseIdentifier: TextMessageCell.identifier)
        cv.register(SoundMessageCell.self, forCellWithReuseIdentifier: SoundMessageCell.identifier)
        cv.register(ImageMessageCell.self, forCellWithReuseIdentifier: ImageMessageCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var messageInputView: ChatInputView = {
        let view = ChatInputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: ChatViewModel
    weak var coordinator: MainCoordinator?
    
    init(otherUserID: String) {
        self.viewModel = ChatViewModel()
        super.init(nibName: nil, bundle: nil)
        viewModel.joinRoom(otherUserID: otherUserID)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(resource: .igBackground)
        configureNavigationBar()
    }
    
    override func configureConstraints() {
        view.addSubview(collection)
        view.addSubview(messageInputView)
        
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: .igText)
    }
    
    
    override func configureViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.collection.reloadData()
            self?.scrollToBottom()
        }
        
        viewModel.onUserLoaded = { [weak self] in
            self?.updateNavigationTitle()
        }
        
        self.messageInputView.onSendMessage = { [weak self] text in
            self?.viewModel.sendMessage(type: .text, content: text)
        }
        
        self.messageInputView.onMicTapped = { [weak self] in
            
        }
        
        self.messageInputView.onGalleryTapped = { [weak self] in
    
        }
    }
    
    private func updateNavigationTitle() {
        guard let chatUser = viewModel.chatUser else { return }
        
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.setImage(urlString: chatUser.profileImageURL)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = chatUser.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = UIColor(resource: .igText)
        
        let activeLabel = UILabel()
        activeLabel.text = "Active now"
        activeLabel.font = .systemFont(ofSize: 12)
        activeLabel.textColor = UIColor(resource: .igPlaceHolder)
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, activeLabel])
        textStack.axis = .vertical
        textStack.spacing = 1
        
        let stack = UIStackView(arrangedSubviews: [avatarImageView, textStack])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        
        navigationItem.titleView = stack
    }
    
    private func scrollToBottom() {
        let count = viewModel.messages.count
        guard count > 0 else { return }
        let indexPath = IndexPath(item: count-1, section: 0)
        collection.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = viewModel.messages[indexPath.item]
        let isCurrentUser = message.senderID == viewModel.currentID
        
        switch message.type {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMessageCell.identifier, for: indexPath) as! TextMessageCell
            cell.configure(message: message, isCurrentUser: isCurrentUser)
            return cell
            
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageMessageCell.identifier, for: indexPath) as! ImageMessageCell
            cell.configure(message: message, isCurrentUser: isCurrentUser)
            cell.onImageTapped = { [weak self] in
                
            }
            return cell
            
        case .voice:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundMessageCell.identifier, for: indexPath) as! SoundMessageCell
            cell.configure(message: message, isCurrentUser: isCurrentUser, duration: message.duration ?? 0)
            cell.onPlayTapped = { [weak self] in
                
            }
            cell.onSliderValueChanged = { value in
                AudioManager.shared.seek(to: value)
            }
            return cell
        }
    }
}
