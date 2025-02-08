//
//  AccountLoginViewController.swift
//  RxSwiftDemo
//
//  Created by Huei-Der Huang on 2025/2/8.
//

import UIKit
import RxCocoa
import RxSwift

class AccountLoginViewController: UIViewController {
    var viewModel: AccountLoginViewModel
    private var usernameLabel = UILabel()
    private var usernameTextField = UITextField()
    private var passwordLabel = UILabel()
    private var passwordTextField = UITextField()
    private var confirmPasswordLabel = UILabel()
    private var confirmPasswordTextField = UITextField()
    private var messageLabel = UILabel()
    private var loginButton = UIButton()
    private var stackView = UIStackView()
    private var disposeBag = DisposeBag()
    
    init(viewModel: AccountLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupRxSwift()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    private func initUI() {
        usernameLabel.text = UIStringModel.UsernameTitle
        usernameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameTextField.placeholder = UIStringModel.UsernamePlaceholder
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.delegate = self
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.text = UIStringModel.PasswordTitle
        passwordLabel.font = .systemFont(ofSize: 16, weight: .medium)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.placeholder = UIStringModel.PasswordPlaceholder
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPasswordLabel.text = UIStringModel.ConfirmPasswordTitle
        confirmPasswordLabel.font = .systemFont(ofSize: 16, weight: .medium)
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPasswordTextField.placeholder = UIStringModel.ConfirmPasswordPlaceholder
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = .systemRed
        messageLabel.textAlignment = .left
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.addTarget(self, action: #selector(onLoginButtonClick), for: .touchUpInside)
        loginButton.setTitle(UIStringModel.LoginTitle, for: .normal)
        loginButton.setTitleColor(.link, for: .normal)
        loginButton.setTitleColor(.systemGray, for: .disabled)
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordLabel)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordLabel)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(messageLabel)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(loginButton)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            usernameLabel.heightAnchor.constraint(equalToConstant: 25),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordLabel.heightAnchor.constraint(equalToConstant: 25),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 25),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            messageLabel.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: loginButton.topAnchor, constant: 20),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupRxSwift() {
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPassword)
            .disposed(by: disposeBag)
        
        viewModel.messagePublisher
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnable
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    @objc private func onLoginButtonClick() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: UIStringModel.LoginSuccess, preferredStyle: .alert)
            let okAction = UIAlertAction(title: UIStringModel.Ok, style: .default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }

}

extension AccountLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
