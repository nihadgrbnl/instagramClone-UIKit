//
//  PostCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 31.03.26.
//

import UIKit

class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = UIColor(resource: .igInputBackground)
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = UIColor(resource: .igPlaceHolder)
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
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(resource: .igInputBackground)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var likeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return btn
    }()
    
    private lazy var commentBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return btn
    }()
    
    private lazy var shareBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return btn
    }()
    
    private lazy var bookmarkBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return btn
    }()
    
    private lazy var leftActionStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [likeBtn, commentBtn, shareBtn])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var likesLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var captionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var commentsLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = UIColor(resource: .igPlaceHolder)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.textColor = UIColor(resource: .igPlaceHolder)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(resource: .igBackground)
        selectionStyle = .none
    }
    
    private func configureConstraints() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(leftActionStack)
        contentView.addSubview(bookmarkBtn)
        contentView.addSubview(likesLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            
            postImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            
            leftActionStack.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            leftActionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            bookmarkBtn.centerYAnchor.constraint(equalTo: leftActionStack.centerYAnchor),
            bookmarkBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            likesLabel.topAnchor.constraint(equalTo: leftActionStack.bottomAnchor, constant: 6),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            captionLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 4),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            commentsLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 4),
            commentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    func configure(post: Post, user: User?) {
        usernameLabel.text = user?.name ?? ""
        likesLabel.text = "\(post.likes) likes"
        timeLabel.text = post.timeStamp.timeAgoString()
        commentsLabel.isHidden = true
        avatarImageView.setImage(urlString: user?.profileImageURL)
        postImageView.setImage(urlString: post.imageURL, placeholder: nil)
        
        if post.caption.isEmpty {
            captionLabel.isHidden = true
        } else {
            captionLabel.isHidden = false
            captionLabel.attributedText = buildCaption(username: user?.name ?? "", caption: post.caption)
        }
    }
    
    private func buildCaption(username: String, caption: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        result.append(NSAttributedString(
            string: username + " ",
            attributes: [
                .font : UIFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: UIColor(resource: .igText)
            ]
        ))
        
        caption.split(separator: " ", omittingEmptySubsequences: false).forEach { word in
            let wordStr = String(word) + " "
            result.append(NSAttributedString(
                string: wordStr,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: word.hasPrefix("#")
                    ? UIColor(resource: .igPurple)
                    : UIColor(resource: .igText)
                ]
            ))
        }
        return result
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        usernameLabel.text = nil
        likesLabel.text = nil
        captionLabel.attributedText = nil
        captionLabel.isHidden = false
        timeLabel.text = nil
    }
    
}
