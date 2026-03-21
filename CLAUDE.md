# Project: InstagramClone-UIKit

## Overview
Instagram-like iOS application built with UIKit.
Programmatic UI (no Storyboard, no XIB), MVVM + Coordinator + Repository pattern.

## Tech Stack
- UI: UIKit — Programmatic (no Storyboard, no XIB)
- Auth + DB: Firebase Auth + Firebase Firestore
- Storage: Firebase Storage (images, audio)
- Local DB: CoreData (MessageEntity)
- Audio: AVFoundation (AudioManager, AudioRecorderManager, AudioDownloadManager)
- Keyboard: IQKeyboardManagerSwift
- Min iOS: 16.0
- Swift: 5.9

## Firebase Collections
- users/{uid} → User model (uid, username, fullname, email, profileImageURL)
- chats/{chatID}/messages → Message model
- users/{uid}/recent_messages/{otherUID} → RecentMessages model

## Folder Structure (DO NOT CHANGE — ask user before modifying)
```
InstagramClone-UIKit/
├── App/
│   ├── AppDelegate.swift         ← Firebase.configure(), IQKeyboard setup, CoreData stack
│   ├── SceneDelegate.swift       ← AppCoordinator başlatılır
│   ├── MainTabBarController.swift
│   └── Persistence.swift
├── Common/
│   ├── Base/BaseController.swift ← Bütün VC'ler buradan miras alır
│   ├── Components/               ← Reusable UIView subclasses (buttons, inputs, etc.)
│   └── Extensions/
│       └── UIImageView+Extension.swift
├── Core/
│   ├── Adapter/                  ← External data → App model dönüşümleri
│   ├── Audio/
│   │   ├── AudioManager.swift          ← Singleton, oynatma
│   │   ├── AudioDownloadManager.swift  ← Singleton, indirme
│   │   └── AudioRecorderManager.swift  ← Singleton, kayıt
│   ├── Builder/                  ← Karmaşık nesne oluşturma (Message, Alert, vb.)
│   ├── Coordinator/
│   │   ├── Coordinator.swift       ← Protocol (navigationController, childCoordinators, start)
│   │   ├── AppCoordinator.swift    ← Ana coordinator, Auth/Main flow yönetimi
│   │   ├── AuthCoordinator.swift   ← Login/Register flow
│   │   └── MainCoordinator.swift   ← TabBar + Chat navigation
│   ├── CoreData/
│   │   ├── MessageEntity+CoreDataClass.swift
│   │   └── MessageEntity+CoreDataProperties.swift
│   ├── Helper/
│   │   └── ChatUtils.swift         ← getChatID(user1:user2:) helper
│   └── Repository/
│       ├── Auth/
│       │   ├── AuthRepository.swift          ← Protocol
│       │   └── FirebaseAuthRepository.swift  ← Implementation
│       ├── Chat/
│       │   ├── ChatRepository.swift          ← Protocol
│       │   └── FirebaseRepository.swift      ← Implementation
│       ├── DMInbox/
│       │   ├── InboxRepository.swift         ← Protocol
│       │   └── FirebaseInboxRepository.swift ← Implementation
│       └── Local/
│           ├── MessageLocalDataSource.swift  ← Protocol
│           └── MessageLocalRepository.swift  ← CoreData implementation
├── Model/
│   ├── User.swift           ← struct, Codable, Identifiable
│   ├── Message.swift        ← struct, Codable, @DocumentID, MessageType enum
│   └── RecentMessages.swift
└── Scene/
    ├── Auth/
    │   ├── Login/
    │   │   ├── LoginViewController.swift  ← BaseController'dan miras
    │   │   └── LoginViewModel.swift
    │   └── Register/
    │       ├── RegisterController.swift   ← BaseController'dan miras
    │       └── RegisterViewModel.swift
    ├── DMInboxController/
    │   ├── Chat/
    │   │   ├── ChatViewController.swift   ← BaseController'dan miras
    │   │   ├── ChatViewModel.swift
    │   │   └── ChatInputView.swift        ← UIView subclass
    │   ├── DMInbox/
    │   │   ├── DMInboxController.swift    ← BaseController'dan miras
    │   │   ├── DMInboxViewModel.swift
    │   │   └── DMInboxCell.swift
    │   └── ReusableCell/
    │       ├── TextMessageCell.swift
    │       ├── SoundMessageCell.swift
    │       └── ImageMessageCell.swift
    ├── Feed/FeedController.swift
    ├── Profile/ProfileController.swift
    ├── Search/SearchController.swift
    └── Upload/UploadController.swift
```

## BaseController Pattern (MUST FOLLOW)
All ViewControllers inherit from BaseController. Override these methods — do NOT put logic directly in viewDidLoad:

```swift
class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()           // 1. UI elementlerini kur
        configureConstraints()  // 2. Constraint'leri ekle
        configureViewModel()    // 3. ViewModel binding
    }

    func configureUI() {}
    func configureConstraints() {}
    func configureViewModel() {}
}
```

When creating a new ViewController:
- Inherit from BaseController (NOT UIViewController directly)
- Override configureUI(), configureConstraints(), configureViewModel()
- Always call super.viewDidLoad() if you override viewDidLoad

## Coordinator Pattern (MUST FOLLOW)
- Navigation logic ONLY in Coordinator — ViewController never pushes/presents directly
- Every ViewController has: weak var coordinator: SomeCoordinator?
- AppCoordinator → manages Auth/Main flow switch
- AuthCoordinator → Login, Register
- MainCoordinator → TabBar tabs + goToChat(message:)
- parentCoordinator is always weak

```swift
// CORRECT
@objc private func signUpTapped() {
    coordinator?.goToRegister()
}

// WRONG
@objc private func signUpTapped() {
    navigationController?.pushViewController(RegisterViewController(), animated: true)
}
```

## Repository Pattern (MUST FOLLOW)
- Every Repository has a Protocol + Firebase implementation
- ViewModel NEVER accesses Firebase directly — always through Repository
- New Firebase feature → create Protocol in Core/Repository/, implement in Firebase*Repository.swift
- Inject repository via init with default value:

```swift
init(repository: AuthRepository = FirebaseAuthRepository()) {
    self.repository = repository
}
```

## ViewModel Rules
- NEVER import UIKit in ViewModel
- Expose closures for UI updates: onSuccess, onError, onDataUpdated, onLoading
- Use [weak self] in all repository callbacks
- UI thread management: DispatchQueue.main.async when calling UI closures

```swift
// CORRECT — ViewModel closure pattern
var onLoginSuccess: (() -> Void)?
var onLoginError: ((String) -> Void)?

// In ViewController configureViewModel():
viewModel.onLoginSuccess = { [weak self] in
    DispatchQueue.main.async {
        self?.coordinator?.didLogin()
    }
}
```

## Code Rules

### General
- No Storyboard, no XIB — everything programmatic
- No force unwrap (!) in production code
- Always use [weak self] in closures
- translatesAutoresizingMaskIntoConstraints = false on all programmatic views
- Use lazy var for UI elements
- Use guard let for early exits

### UI Elements
- Declare as private lazy var
- Set translatesAutoresizingMaskIntoConstraints = false inside the closure
- Add to view in configureConstraints()
- Activate constraints with NSLayoutConstraint.activate([])

### Colors
- Use UIColor(resource: .igBackground), .igText, .igPurple, .igBorder, .igPlaceHolder, .igInputBackground
- Do NOT use hardcoded UIColor(red:green:blue:) values

### Cells
- Always define static let identifier = "CellName"
- Register in the collection/table view setup
- Dequeue with as? (guard let) — NEVER as!

### Audio
- AudioManager.shared → playback
- AudioDownloadManager.shared → download
- AudioRecorderManager.shared → recording
- These are Singletons — do NOT create new instances

## Naming Conventions
- ViewController : ChatViewController, LoginViewController (some use Controller suffix — follow existing pattern)
- ViewModel      : ChatViewModel, LoginViewModel
- Repository Protocol : ChatRepository, AuthRepository, InboxRepository
- Repository Impl: FirebaseRepository, FirebaseAuthRepository, FirebaseInboxRepository
- Coordinator    : AppCoordinator, AuthCoordinator, MainCoordinator
- Cell           : DMInboxCell, TextMessageCell, SoundMessageCell
- Extension file : UIImageView+Extension.swift

## Error Handling — AppError (MUST FOLLOW)
- NEVER pass Firebase error.localizedDescription directly to UI
- Always map Firebase errors to AppError before calling onError closure
- AppError is defined in Core/Helper/AppError.swift

```swift
// Core/Helper/AppError.swift
enum AppError: Error {
    case invalidCredentials
    case userNotFound
    case networkError
    case uploadFailed
    case decodingFailed
    case unknown(String)

    var userFriendlyMessage: String {
        switch self {
        case .invalidCredentials: return "Email or password is incorrect."
        case .userNotFound:       return "No account found with this email."
        case .networkError:       return "Please check your internet connection."
        case .uploadFailed:       return "File could not be uploaded. Please try again."
        case .decodingFailed:     return "Something went wrong. Please try again."
        case .unknown(let msg):   return msg
        }
    }
}

// CORRECT — map to AppError
repository.login(email: email, password: password) { [weak self] success, error in
    if let error {
        let appError = AppError.from(error)
        self?.onLoginError?(appError.userFriendlyMessage)
    } else {
        self?.onLoginSuccess?()
    }
}

// WRONG — Firebase error direkt göster
self?.onLoginError?(error.localizedDescription)
```

## Adapter Pattern (Core/Adapter/)
Use Adapter whenever external data (Firebase, API, CoreData) needs to be converted to app models.
This is a project-wide pattern — apply it wherever data enters the app boundary, not just in one feature.

```swift
// Core/Adapter/UserAdapter.swift
struct UserAdapter {
    static func adapt(_ document: DocumentSnapshot) -> User? {
        return try? document.data(as: User.self)
    }
}

// Core/Adapter/MessageAdapter.swift
struct MessageAdapter {
    static func adapt(_ document: QueryDocumentSnapshot) -> Message? {
        return try? document.data(as: Message.self)
    }
}

// CORRECT — use Adapter in Repository
if let message = MessageAdapter.adapt(change.document) {
    localRepository.save(chatID: chatID, model: message)
}

// WRONG — decode directly in Repository
if let message = try? change.document.data(as: Message.self) { }
```

When to use Adapter:
- Firebase DocumentSnapshot → any app model (User, Message, RecentMessages, Post, Comment, etc.)
- Any external data source → internal app model
- New model added to the app → create corresponding Adapter in Core/Adapter/

Naming: UserAdapter, MessageAdapter, RecentMessageAdapter, PostAdapter, CommentAdapter
New Adapter files go to: Core/Adapter/

## Builder Pattern (Core/Builder/)
Use Builder for complex objects with many parameters, or objects built differently depending on context.
This is a project-wide pattern — apply it whenever object construction is verbose or repeated.

```swift
// Core/Builder/MessageBuilder.swift
class MessageBuilder {
    private var type: MessageType = .text
    private var content: String = ""
    private var chatID: String = ""
    private var duration: Double? = nil
    private var currentUser: User? = nil
    private var chatUser: User? = nil

    func setType(_ type: MessageType) -> MessageBuilder {
        self.type = type
        return self
    }

    func setContent(_ content: String) -> MessageBuilder {
        self.content = content
        return self
    }

    func setChatID(_ chatID: String) -> MessageBuilder {
        self.chatID = chatID
        return self
    }

    func setDuration(_ duration: Double) -> MessageBuilder {
        self.duration = duration
        return self
    }

    func setUsers(current: User, chat: User) -> MessageBuilder {
        self.currentUser = current
        self.chatUser = chat
        return self
    }

    func build() -> MessagePayload? {
        guard !chatID.isEmpty,
              let currentUser = currentUser,
              let chatUser = chatUser else { return nil }
        return MessagePayload(
            type: type,
            content: content,
            chatID: chatID,
            duration: duration,
            currentUser: currentUser,
            chatUser: chatUser
        )
    }
}

// Core/Builder/AlertBuilder.swift
class AlertBuilder {
    private var title: String = ""
    private var message: String = ""
    private var primaryTitle: String = "OK"
    private var primaryAction: (() -> Void)? = nil
    private var secondaryTitle: String? = nil
    private var secondaryAction: (() -> Void)? = nil

    func setTitle(_ title: String) -> AlertBuilder { self.title = title; return self }
    func setMessage(_ message: String) -> AlertBuilder { self.message = message; return self }
    func setPrimaryButton(_ title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        self.primaryTitle = title; self.primaryAction = action; return self
    }
    func setSecondaryButton(_ title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        self.secondaryTitle = title; self.secondaryAction = action; return self
    }

    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: primaryTitle, style: .default) { _ in self.primaryAction?() })
        if let secondaryTitle = secondaryTitle {
            alert.addAction(UIAlertAction(title: secondaryTitle, style: .cancel) { _ in self.secondaryAction?() })
        }
        return alert
    }
}

// CORRECT — Builder ile kullan
let payload = MessageBuilder()
    .setType(.text)
    .setContent(text)
    .setChatID(chatID)
    .setUsers(current: currentUser, chat: chatUser)
    .build()

let alert = AlertBuilder()
    .setTitle("Error")
    .setMessage(error.userFriendlyMessage)
    .setPrimaryButton("Try Again") { [weak self] in self?.retry() }
    .setSecondaryButton("Cancel")
    .build()
present(alert, animated: true)
```

When to use Builder:
- Any object with 3+ parameters where some are optional
- Objects built differently depending on context (text message vs voice message vs image message)
- UIAlertController — always use AlertBuilder instead of inline UIAlertController
- Future: Post creation, Comment creation, any similarly complex payload

New Builder files go to: Core/Builder/
Naming: MessageBuilder, AlertBuilder, PostBuilder, CommentBuilder

## isLoggedIn State
- Stored in UserDefaults.standard with key "isLoggedIn"
- Set to true on login/register success
- Set to false on logout
- Read in AppCoordinator.start() to decide initial flow

## Checklist (apply to EVERY new file)
- [ ] No force unwrap
- [ ] No force cast (as!) — use as? with guard let
- [ ] No UIKit in ViewModel
- [ ] [weak self] in ALL closures — including ViewModel repository callbacks
- [ ] UI updates on main thread
- [ ] Firebase errors mapped to AppError — never pass localizedDescription directly to UI
- [ ] No navigation logic in ViewController — use Coordinator
- [ ] Repository pattern followed — no direct Firebase in ViewModel
- [ ] Firebase → Model conversions go through Adapter (Core/Adapter/)
- [ ] Complex object creation uses Builder (Core/Builder/)
- [ ] UIAlertController created via AlertBuilder
- [ ] translatesAutoresizingMaskIntoConstraints = false
- [ ] Inherits from BaseController (not UIViewController)
- [ ] configureUI / configureConstraints / configureViewModel overridden
