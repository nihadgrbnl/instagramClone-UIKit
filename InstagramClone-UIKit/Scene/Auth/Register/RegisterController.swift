//
//  RegisterController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 12.03.26.
//

import UIKit

class RegisterViewController: BaseController {
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SocialApp"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(resource: .igText)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up to see photos and videos from your friends."
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(resource: .igPlaceHolder)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var facebookBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in with Facebook", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(resource: .igPurple)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.setImage(UIImage(systemName: "f.cursive.circle"), for: .normal)
        btn.tintColor = .white
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(resource: .igPlaceHolder)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .igBorder)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .igBorder)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        return makeTextField(placeholder: "Mobile Number or Email")
    }()
    
    private lazy var fullNameTextField: UITextField = {
        return makeTextField(placeholder: "Full Name")
    }()
    
    private lazy var usernameTextField: UITextField = {
        return makeTextField(placeholder: "Username")
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = makeTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.rightView = showPasswordBtn
        tf.rightViewMode = .always
        return tf
    }()
    
    private lazy var showPasswordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.tintColor = UIColor(resource: .igPlaceHolder)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return btn
    }()
    
    private lazy var disclaimerLabel: UILabel = {
        let label = UILabel()
        let fullText = "By signing up, you agree to our Terms, Privacy Policy and Cookies Policy."
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .foregroundColor: UIColor(resource: .igPlaceHolder),
                .font: UIFont.systemFont(ofSize: 12)
            ]
        )
        let links = ["Terms", "Privacy Policy", "Cookies Policy"]
        links.forEach { link in
            let range = (fullText as NSString).range(of: link)
            attributedString.addAttribute(.foregroundColor, value: UIColor(resource: .igPurple), range: range)
        }
        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(resource: .igPurple)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        let text = "Have an account? "
        let boldText = "Log in."
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor(resource: .igText),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        attributedString.append(NSAttributedString(
            string: boldText,
            attributes: [
                .foregroundColor: UIColor(resource: .igPurple),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        ))
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return btn
    }()
    
    private let viewModel = RegisterViewModel()
    weak var coordinator: AuthCoordinator?
    
    
    override func configureUI() {
        view.backgroundColor = UIColor(resource: .igBackground)
    }
    
    override func configureConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(facebookBtn)
        view.addSubview(leftLine)
        view.addSubview(orLabel)
        view.addSubview(rightLine)
        view.addSubview(emailTextField)
        view.addSubview(fullNameTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(disclaimerLabel)
        view.addSubview(signUpBtn)
        view.addSubview(loginBtn)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            facebookBtn.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            facebookBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            facebookBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            facebookBtn.heightAnchor.constraint(equalToConstant: 50),
            
            orLabel.topAnchor.constraint(equalTo: facebookBtn.bottomAnchor, constant: 20),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: facebookBtn.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -12),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            
            rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 12),
            rightLine.trailingAnchor.constraint(equalTo: facebookBtn.trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            
            emailTextField.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: facebookBtn.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: facebookBtn.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            fullNameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            fullNameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 12),
            usernameTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            disclaimerLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            disclaimerLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            disclaimerLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            signUpBtn.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor, constant: 20),
            signUpBtn.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signUpBtn.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signUpBtn.heightAnchor.constraint(equalToConstant: 50),
            
            loginBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
        
    private func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = UIColor(resource: .igInputBackground)
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(resource: .igBorder).cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = UIColor(resource: .igText)
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(resource: .igPlaceHolder)]
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    override func configureViewModel() {
        viewModel.onRegisterSuccess = {
            DispatchQueue.main.async {
                self.coordinator?.didRegister(email: self.viewModel.email)
            }
        }
        
        viewModel.onRegisterError = { errorMessage in
            DispatchQueue.main.async {
                print(errorMessage)
            }
        }
    }
    
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func signUpTapped() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.fullName = fullNameTextField.text ?? ""
        viewModel.username = usernameTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.register()
    }
    
    @objc private func loginTapped() {
        navigationController?.popViewController(animated: true)
    }
}
