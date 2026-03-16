//
//  SoundMessageCell.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 16.03.26.
//

import UIKit

class SoundMessageCell: UICollectionViewCell {
    
    
    static let identifier = "SoundMessageCell"
    
    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var playPauseBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        btn.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var slider: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return s
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.text = "00:00"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var durationLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.text = "00:00"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var separatorLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.text = "/"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.textColor = UIColor(resource: .igPlaceHolder)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var onPlayTapped: (() -> Void)?
    var onSliderValueChanged: ((Double) -> Void)?
    
    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!
    private var timeLabelLeadingConstraint: NSLayoutConstraint?
    private var timeLabelTrailingConstraint: NSLayoutConstraint?
    
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
        contentView.addSubview(timeLabel)
        bubbleView.addSubview(playPauseBtn)
        bubbleView.addSubview(loadingIndicator)
        bubbleView.addSubview(slider)
        bubbleView.addSubview(currentTimeLabel)
        bubbleView.addSubview(separatorLabel)
        bubbleView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 32),
            avatarImageView.heightAnchor.constraint(equalToConstant: 32),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            bubbleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.65),
            
            playPauseBtn.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            playPauseBtn.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            playPauseBtn.widthAnchor.constraint(equalToConstant: 28),
            playPauseBtn.heightAnchor.constraint(equalToConstant: 28),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: playPauseBtn.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            
            slider.leadingAnchor.constraint(equalTo: playPauseBtn.trailingAnchor, constant: 8),
            slider.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            slider.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: playPauseBtn.trailingAnchor, constant: 8),
            currentTimeLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 4),
            currentTimeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            
            separatorLabel.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 2),
            separatorLabel.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            
            durationLabel.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor, constant: 2),
            durationLabel.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyBubbleShape()
    }
    
    func configure(message: Message, isCurrentUser: Bool, duration: Double) {
        timeLabel.text = message.timeStamp.formatted(date: .omitted, time: .shortened)
        slider.maximumValue = Float(duration > 0 ? duration : 1.0)
        durationLabel.text = formatTime(duration)
        
        bubbleLeadingConstraint.isActive = false
        bubbleTrailingConstraint.isActive = false
        timeLabelLeadingConstraint?.isActive = false
        timeLabelTrailingConstraint?.isActive = false
        
        if isCurrentUser {
            bubbleView.backgroundColor = UIColor(resource: .igPurple)
            playPauseBtn.tintColor = .white
            slider.tintColor = .white
            currentTimeLabel.textColor = .white.withAlphaComponent(0.8)
            separatorLabel.textColor = .white.withAlphaComponent(0.8)
            durationLabel.textColor = .white.withAlphaComponent(0.8)
            avatarImageView.isHidden = true
            
            bubbleTrailingConstraint.isActive = true
            bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 60)
            bubbleLeadingConstraint.isActive = true
            
            timeLabelTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor)
            timeLabelTrailingConstraint?.isActive = true
        } else {
            bubbleView.backgroundColor = UIColor(resource: .igInputBackground)
            playPauseBtn.tintColor = UIColor(resource: .igText)
            slider.tintColor = UIColor(resource: .igPurple)
            currentTimeLabel.textColor = UIColor(resource: .igPlaceHolder)
            separatorLabel.textColor = UIColor(resource: .igPlaceHolder)
            durationLabel.textColor = UIColor(resource: .igPlaceHolder)
            avatarImageView.isHidden = false
            
            bubbleLeadingConstraint.isActive = true
            bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -60)
            bubbleTrailingConstraint.isActive = true
            
            timeLabelLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor)
            timeLabelLeadingConstraint?.isActive = true
        }
    }
    
    func updatePlayState(isPlaying: Bool, currentTime: Double, isDownloading: Bool) {
        if isDownloading {
            loadingIndicator.startAnimating()
            playPauseBtn.isHidden = true
        } else {
            loadingIndicator.stopAnimating()
            playPauseBtn.isHidden = false
            let imageName = isPlaying ? "pause.fill" : "play.fill"
            playPauseBtn.setImage(UIImage(systemName: imageName), for: .normal)
        }
        
        slider.value = Float(currentTime)
        currentTimeLabel.text = formatTime(currentTime)
    }
    
    private func applyBubbleShape() {
        guard bubbleView.bounds != .zero else { return }
        let isCurrentUser = !avatarImageView.isHidden == false
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
    
    private func formatTime(_ seconds: Double) -> String {
        let total = Int(seconds)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
    
    @objc private func playPauseTapped() {
        onPlayTapped?()
    }
    
    @objc private func sliderChanged() {
        onSliderValueChanged?(Double(slider.value))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleView.layer.mask = nil
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        slider.value = 0
        currentTimeLabel.text = "00:00"
        playPauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseBtn.isHidden = false
        loadingIndicator.stopAnimating()
    }
}
