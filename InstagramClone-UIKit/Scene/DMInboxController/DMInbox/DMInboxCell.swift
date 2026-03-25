//
//  DMInboxCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 13.03.26.
//

import UIKit

class DMInboxCell: UITableViewCell {
    
    static let identifier = "DMInboxCell"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 28
        iv.backgroundColor = UIColor(resource: .igInputBackground)
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = UIColor(resource: .igPlaceHolder)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(resource: .igText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(resource: .igPlaceHolder)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .igPlaceHolder)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var unreadDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .igPurple)
        view.layer.cornerRadius = 5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cameraIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "camera")
        iv.tintColor = UIColor(resource: .igPlaceHolder)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func configureUI () {
        backgroundColor = UIColor(resource: .igBackground)
        selectionStyle = .none
    }
    
    private func configureConstraints() {
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unreadDot)
        contentView.addSubview(cameraIcon)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
            
            cameraIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cameraIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cameraIcon.widthAnchor.constraint(equalToConstant: 22),
            cameraIcon.heightAnchor.constraint(equalToConstant: 22),
            
            unreadDot.trailingAnchor.constraint(equalTo: cameraIcon.leadingAnchor, constant: -12),
            unreadDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unreadDot.widthAnchor.constraint(equalToConstant: 10),
            unreadDot.heightAnchor.constraint(equalToConstant: 10),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: unreadDot.leadingAnchor, constant: -8),
            
            lastMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),

            timeLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: lastMessageLabel.trailingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: unreadDot.leadingAnchor, constant: -12),
        ])
    }
    
    func configure(message: RecentMessages) {
        usernameLabel.text = message.username
        lastMessageLabel.text = message.text
        timeLabel.text = message.timeString
        unreadDot.isHidden = message.isSeen
        avatarImageView.setImage(urlString: message.profileImageURL)
        
        if message.isSeen {
            usernameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            lastMessageLabel.font = .systemFont(ofSize: 13)
            lastMessageLabel.textColor = UIColor(resource: .igPlaceHolder)
        } else {
            usernameLabel.font = .systemFont(ofSize: 14, weight: .bold)
            lastMessageLabel.font = .systemFont(ofSize: 13, weight: .semibold)
            lastMessageLabel.textColor = UIColor(resource: .igText)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        usernameLabel.text = nil
        lastMessageLabel.text = nil
        timeLabel.text = nil
    }
}
