//
//  ViewController.swift
//  InstagramClone-UIKit
//
//  Created by Nihad Gurbanli on 11.03.26.
//

import UIKit

class LoginViewController: BaseController {
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Social App"
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textColor = UIColor(resource: .igText)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone number, username or email"
        tf.backgroundColor = UIColor(resource: .igInputBackground)
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(resource: .igBorder).cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = UIColor(resource: .igText)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Phone number, username or email",
            attributes: [.foregroundColor: UIColor(resource: .igPlaceHolder)]
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(resource: .igInputBackground)
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor(resource: .igBorder).cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = UIColor(resource: .igText)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: UIColor(resource: .igPlaceHolder)]
        )
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var showPasswordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        btn.tintColor = UIColor(resource: .igPlaceHolder)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forgotPasswordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot Password?", for: .normal)
        btn.setTitleColor(UIColor(resource: .igPurple), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(resource: .igPurple)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
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
    
    private lazy var facebookBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log in with Facebook", for: .normal)
        btn.setTitleColor(UIColor(resource: .igPurple), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        btn.setImage(UIImage(systemName: "f.cursive.circle"), for: .normal) //bura facebook logo elave et
        btn.tintColor = UIColor(resource: .igPurple)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        let text = "Don't have an account?"
        let boldText = " Sign up."
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
        btn.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return btn
    }()
    
    private let viewModel = LoginViewModel()
    
    weak var coordinator: AuthCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(resource: .igBackground)
        passwordTextField.rightView = showPasswordBtn
        passwordTextField.rightViewMode = .always
        
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }
    
    override func configureConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordBtn)
        view.addSubview(loginBtn)
        view.addSubview(leftLine)
        view.addSubview(orLabel)
        view.addSubview(rightLine)
        view.addSubview(facebookBtn)
        view.addSubview(signUpBtn)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            forgotPasswordBtn.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -10),
            
            loginBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 16),
            loginBtn.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginBtn.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            
            orLabel.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 24),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -12),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            
            rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 12),
            rightLine.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            
            facebookBtn.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 24),
            facebookBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            signUpBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override func configureViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            self?.coordinator?.didLogin()
        }
        
        viewModel.onLoginError = { [weak self] errorMessage in
            let alert = AlertBuilder()
                .setTitle("Hata")
                .setMessage(errorMessage)
                .setPrimaryButton("Tamam")
                .build()
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            self?.loginBtn.isEnabled = !isLoading
            self?.loginBtn.setTitle(isLoading ? "" : "Log In", for: .normal)
            isLoading ? self?.loginBtn.setTitle("", for: .normal) : nil
            self?.loginBtn.alpha = isLoading ? 0.7 : 1.0
        }
    }
    
    
    func prefillEmail(email: String) {
        emailTextField.text = email
        viewModel.email = email
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        showPasswordBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func loginTapped() {
        view.endEditing(true)
        viewModel.login()
    }
    
    @objc private func signUpTapped() {
        coordinator?.goToRegister()
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
}
