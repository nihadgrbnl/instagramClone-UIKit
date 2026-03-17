//
//  TextMessageCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 16.03.26.
//

import UIKit

class TextMessageCell: UICollectionViewCell {
    
    static let identifier = "TextMessageCell"
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
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
    
    private var bubbleLeadingConstraints: NSLayoutConstraint!
    private var bubbleTrailingConstraints: NSLayoutConstraint!
    private var timeLabelLeadingConstraint: NSLayoutConstraint?
    private var timeLabelTrailingConstraint: NSLayoutConstraint?
    
    private var isCurrentUser: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 260),
            
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
        
        bubbleLeadingConstraints = bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8)
        bubbleTrailingConstraints = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    func configure(message: Message, isCurrentUser: Bool) {
        self.isCurrentUser = isCurrentUser
        messageLabel.text = message.content
        timeLabel.text = message.timeStamp.formatted(date: .omitted, time: .shortened)
        
        bubbleLeadingConstraints.isActive = false
        bubbleTrailingConstraints.isActive = false
        timeLabelLeadingConstraint?.isActive = false
        timeLabelTrailingConstraint?.isActive = false
        
        if isCurrentUser {
            bubbleView.backgroundColor = UIColor(resource: .igPurple)
            messageLabel.textColor = .white
            avatarImageView.isHidden = true
            
            bubbleTrailingConstraints.isActive = true
            bubbleLeadingConstraints = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 60)
            bubbleLeadingConstraints.isActive = true
            
            timeLabelTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)
            timeLabelTrailingConstraint?.isActive = true
            
        } else {
            bubbleView.backgroundColor = UIColor(resource: .igInputBackground)
            messageLabel.textColor = UIColor(resource: .igText)
            avatarImageView.isHidden = false
            
            bubbleLeadingConstraints.isActive = true
            bubbleTrailingConstraints = bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60)
            bubbleTrailingConstraints.isActive = true
            
            timeLabelLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor)
            timeLabelLeadingConstraint?.isActive = true
        }
        applyBubbleShape()
    }
    
    private func applyBubbleShape() {
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
        bubbleView.layer.maskedCorners = isCurrentUser
        ? [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        : [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        timeLabelLeadingConstraint?.isActive = false
        timeLabelTrailingConstraint?.isActive = false
        bubbleLeadingConstraints.isActive = false
        bubbleTrailingConstraints.isActive = false
    }
}
