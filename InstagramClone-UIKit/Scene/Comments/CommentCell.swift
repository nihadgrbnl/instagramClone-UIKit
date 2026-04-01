//
//  CommentCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 01.04.26.
//

import UIKit

class CommentCell: UITableViewCell {
    
    static let identifier = "CommentCell"
    
    private lazy var usernameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = UIColor(resource: .igText)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var commentLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = UIColor(resource: .igText)
        l.numberOfLines = 0
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
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(comment: Comment) {
        usernameLabel.text = comment.ownerUsername
        commentLabel.text = comment.text
        timeLabel.text = comment.timeStampt?.timeAgoString() ?? "Just Now"
    }
}
