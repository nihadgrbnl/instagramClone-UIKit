//
//  UserSearchCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import UIKit

class UserSearchCell: UITableViewCell {
    
    static let identifier = "UserSearchCell"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        iv.backgroundColor = UIColor(resource: .igInputBackground)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
        l.font = .systemFont(ofSize: 13)
        l.textColor = UIColor(resource: .igPlaceHolder)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var labelStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [usernameLabel, fullNameLabel])
        sv.axis = .vertical
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI () {
        backgroundColor = UIColor(resource: .igBackground)
        selectionStyle = .none
    }
    
    private func configureConstraints () {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(labelStack)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44),
            avatarImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            labelStack.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            labelStack.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(user: User) {
        usernameLabel.text = user.name
        fullNameLabel.text = user.fullName
        avatarImageView.setImage(urlString: user.profileImageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        usernameLabel.text = nil
        fullNameLabel.text = nil
    }
    
}
