//
//  ImageMessageCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 16.03.26.
//

import UIKit

class ImageMessageCell: UICollectionViewCell {
    
    static let identifier = "ImageMessageCell"
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(resource: .igInputBackground)
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = UIColor(resource: .igPlaceHolder)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var onImageTapped: (() -> Void)?
    
    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!
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
        bubbleView.addSubview(messageImageView)
        bubbleView.addSubview(loadingIndicator)
        contentView.addSubview(timeLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        messageImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bubbleView.widthAnchor.constraint(equalToConstant: 200),
            bubbleView.heightAnchor.constraint(equalToConstant: 200),
            
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            messageImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            messageImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bubbleView.layer.mask != nil {
            applyBubbleShape()
        }
    }
    
    func configure(message: Message, isCurrentUser: Bool) {
        self.isCurrentUser = isCurrentUser
        timeLabel.text = message.timeStamp.formatted(date: .omitted, time: .shortened)
        
        bubbleLeadingConstraint.isActive = false
        bubbleTrailingConstraint.isActive = false
        timeLabelLeadingConstraint?.isActive = false
        timeLabelTrailingConstraint?.isActive = false
        
        if isCurrentUser {
            avatarImageView.isHidden = true
            bubbleTrailingConstraint.isActive = true
            bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 60)
            bubbleLeadingConstraint.isActive = true
            timeLabelTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)
            timeLabelTrailingConstraint?.isActive = true
        } else {
            avatarImageView.isHidden = false
            bubbleLeadingConstraint.isActive = true
            bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60)
            bubbleTrailingConstraint.isActive = true
            timeLabelLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor)
            timeLabelLeadingConstraint?.isActive = true
        }
        
        loadingIndicator.startAnimating()
        messageImageView.image = nil
        messageImageView.setImage(urlString: message.content) { [weak self] _ in
            self?.loadingIndicator.stopAnimating()
        }
        bubbleView.layer.mask = CAShapeLayer()
    }
    
    private func applyBubbleShape() {
        
        let corners: UIRectCorner = isCurrentUser
        ? [.topLeft, .topRight, .bottomLeft]
        : [.topLeft, .topRight, .bottomRight]
        
        let path = UIBezierPath(
            roundedRect: bubbleView.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: 16, height: 16)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        bubbleView.layer.mask = mask
    }
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = nil
        bubbleView.layer.mask = nil
        loadingIndicator.stopAnimating()
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        timeLabelLeadingConstraint?.isActive = false
        timeLabelTrailingConstraint?.isActive = false
    }
}
