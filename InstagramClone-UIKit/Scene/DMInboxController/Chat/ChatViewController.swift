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
            guard let self = self else { return }
            let oldCount = self.collection.numberOfItems(inSection: 0)
            let newCount = self.viewModel.messages.count
            
            if newCount > oldCount {
                let indexPaths = (oldCount..<newCount).map { IndexPath(item: $0, section: 0) }
                self.collection.insertItems(at: indexPaths)
                self.scrollToBottom()
            } else {
                self.collection.reloadData()
                self.scrollToBottom()
            }
            self.viewModel.markAsRead()
            self.updateEmptyState()
        }
        
        viewModel.onUserLoaded = { [weak self] in
            self?.updateNavigationTitle()
            self?.viewModel.markAsRead()
            self?.updateEmptyState()
        }
        
        self.messageInputView.onSendMessage = { [weak self] text in
            self?.viewModel.sendMessage(type: .text, content: text)
        }
        
        viewModel.setupAudioManager()
        
        viewModel.onAudioStateChanged = { [weak self] state in
            guard let self = self,
                  let messageID = state.messageId else { return }
            
            guard let index = self.viewModel.messages.firstIndex(where: { $0.id == messageID }) else { return }
            let indexPath = IndexPath(item: index, section: 0)
            
            guard let cell = self.collection.cellForItem(at: indexPath) as? SoundMessageCell else { return }
            cell.updatePlayState(
                isPlaying: state.isPlaying,
                currentTime: state.currentTime,
                duration: state.duration,
                isDownloading: false
            )
        }
        
        self.messageInputView.onMicTapped = { [weak self] in
            AudioRecorderManager.shared.requestPermission { granted in
                DispatchQueue.main.async {
                    let isRecording = self?.viewModel.toggleRecording(permissionGranted: granted) ?? false
                    self?.messageInputView.updateRecordingState(isRecording: isRecording)
                }
            }
        }
        
        self.messageInputView.onGalleryTapped = { [weak self] in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }
    }
    
    private func updateEmptyState() {
        if viewModel.messages.isEmpty {
            let label = UILabel()
            label.text = "Say hi 👋"
            label.font = .systemFont(ofSize: 15)
            label.textColor = .tertiaryLabel
            label.textAlignment = .center
            collection.backgroundView = label
        } else {
            collection.backgroundView = nil
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
        coordinator?.goBack()
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMessageCell.identifier, for: indexPath) as? TextMessageCell else {
                return UICollectionViewCell()
            }
            cell.configure(message: message, isCurrentUser: isCurrentUser)
            return cell
            
        case .image:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageMessageCell.identifier, for: indexPath) as? ImageMessageCell else {
                return UICollectionViewCell()
            }
            cell.configure(message: message, isCurrentUser: isCurrentUser)
            cell.onImageTapped = { [weak self] in
                //
            }
            return cell
            
        case .voice:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundMessageCell.identifier, for: indexPath) as? SoundMessageCell else {
                return UICollectionViewCell()
            }
            cell.configure(message: message, isCurrentUser: isCurrentUser, duration: message.duration ?? 0)
            
            let isThisMessagePlaying = (AudioManager.shared.currentMessageId == message.id) && AudioManager.shared.isPlaying
            let currentAudioTime = (AudioManager.shared.currentMessageId == message.id) ? AudioManager.shared.currentTime : 0
            
            cell.updatePlayState(
                isPlaying: isThisMessagePlaying,
                currentTime: currentAudioTime,
                duration: nil,
                isDownloading: false
            )
            
            cell.onPlayTapped = { [weak self] in
                guard let id = message.id else { return }
                self?.viewModel.handlePlayTapped(messageID: id, audioURL: message.content)
            }
            cell.onSeekCompleted = { value in
                AudioManager.shared.seek(to: value)
            }
            return cell
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        viewModel.sendImageMessage(imageData: imageData)
        dismiss(animated: true)
    }
}
