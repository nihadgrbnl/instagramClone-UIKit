//
//  ChatInputView.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 17.03.26.
//

import UIKit

class ChatInputView: UIView {
    
    private lazy var messageTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Message...",
            attributes: [.foregroundColor: UIColor(resource: .igPlaceHolder)]
            
        )
        tf.backgroundColor = UIColor(resource: .igInputBackground)
        tf.layer.cornerRadius = 20
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.font = .systemFont(ofSize: 15)
        tf.textColor = UIColor(resource: .igText)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.tintColor = UIColor(resource: .igPurple)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var micBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "mic"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(micTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var galleryBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        btn.tintColor = UIColor(resource: .igText)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sendBtn, micBtn, galleryBtn])
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var onSendMessage: ((String) -> Void)?
    var onMicTapped: (() -> Void)?
    var onGalleryTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor(resource: .igBackground)
        
        
    }
    
    private func configureConstraints() {
        addSubview(messageTextField)
        addSubview(rightStack)
        
        NSLayoutConstraint.activate([
            rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            rightStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            sendBtn.widthAnchor.constraint(equalToConstant: 28),
            sendBtn.heightAnchor.constraint(equalToConstant: 28),
            micBtn.widthAnchor.constraint(equalToConstant: 28),
            micBtn.heightAnchor.constraint(equalToConstant: 28),
            galleryBtn.widthAnchor.constraint(equalToConstant: 28),
            galleryBtn.heightAnchor.constraint(equalToConstant: 28),
            
            messageTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            messageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            messageTextField.heightAnchor.constraint(equalToConstant: 44),
            messageTextField.trailingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: -8),
        ])
    }
    
    private func updateButtonState(hasText: Bool) {
        self.sendBtn.isHidden  = !hasText
        self.micBtn.isHidden = hasText
        self.galleryBtn.isHidden = hasText
    }
    
    func updateRecordingState(isRecording: Bool) {
        if isRecording {
            micBtn.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
            micBtn.tintColor = .red
            messageTextField.attributedPlaceholder = NSAttributedString(
                string: "Recording...",
                attributes: [.foregroundColor: UIColor.red]
            )
            messageTextField.isEnabled = false
        } else {
            micBtn.setImage(UIImage(systemName: "mic"), for: .normal)
            micBtn.tintColor = UIColor(resource: .igText)
            messageTextField.attributedPlaceholder = NSAttributedString(
                string: "Message...",
                attributes: [.foregroundColor: UIColor(resource: .igPlaceHolder)]
            )
            messageTextField.isEnabled = true
        }
    }
    
    @objc private func textChanged() {
        let hasText = !(messageTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        updateButtonState(hasText: hasText)
    }
    
    @objc private func sendTapped() {
        guard let text = messageTextField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        onSendMessage?(text)
        messageTextField.text = ""
        updateButtonState(hasText: false)
    }
    
    @objc private func micTapped() {
        onMicTapped?()
    }
    
    @objc private func galleryTapped() {
        onGalleryTapped?()
    }
    
    
}

extension ChatInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}
