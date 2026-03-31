//
//  ProfileHeaderView.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    static let identifier = "ProfileHeaderView"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.backgroundColor = .secondarySystemBackground
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var postsStatView = makeStatView(title: "Posts")
    private lazy var followersStatView = makeStatView(title: "Followers")
    private lazy var followingStatView = makeStatView(title: "Following")
    
    private lazy var statsStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [postsStatView, followersStatView, followingStatView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var editProfileButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.tintColor = UIColor(resource: .igText)
        btn.layer.cornerRadius = 6
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(resource: .igPurple).cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avatarImageView)
        addSubview(statsStack)
        addSubview(usernameLabel)
        addSubview(fullNameLabel)
        addSubview(editProfileButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            statsStack.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            statsStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            fullNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            fullNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            editProfileButton.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 12),
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editProfileButton.heightAnchor.constraint(equalToConstant: 34),
            editProfileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User, postCount: Int) {
        avatarImageView.setImage(urlString: user.profileImageURL)
        usernameLabel.text = user.name
        fullNameLabel.text = user.fullName
        updateStat(view: postsStatView, count: postCount)
        updateStat(view: followersStatView, count: 0)
        updateStat(view: followingStatView, count: 0)
    }
    
    private func makeStatView(title: String) -> UIView {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.font = .systemFont(ofSize: 16, weight: .bold)
        countLabel.textColor = UIColor(resource: .igText)
        countLabel.textAlignment = .center
        countLabel.tag = 100
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = UIColor(resource: .igText)
        titleLabel.textAlignment = .center
        
        let sv = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .center
        return sv
    }
    
    private func updateStat(view: UIView, count: Int) {
        guard let stack = view as? UIStackView,
              let label = stack.arrangedSubviews.first(where: { $0.tag == 100 }) as? UILabel else { return }
        label.text = "\(count)"
    }
}
