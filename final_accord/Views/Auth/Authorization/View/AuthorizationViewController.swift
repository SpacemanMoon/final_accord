import UIKit

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let imageView = UIImageView()
    private let authorizationLabel = UILabel()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let passwordResetButton = UIButton()
    private let authorizationButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    var presenter: AuthorizationPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupKeyboardDismissGesture()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView.image = UIImage(named: "backgroundAuth")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.9
        
        authorizationLabel.text = "Авторизация"
        authorizationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        authorizationLabel.layer.shadowColor = UIColor.black.cgColor
        authorizationLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        authorizationLabel.layer.shadowOpacity = 0.3
        authorizationLabel.layer.shadowRadius = 4
        
        emailTextField.configure(with: .email)
        passwordTextField.configure(with: .password)
        
        passwordResetButton.setTitle("Забыли пароль?", for: .normal)
        passwordResetButton.backgroundColor = .clear
        passwordResetButton.setTitleColor(.black, for: .normal)
        
        authorizationButton.setTitle("Войти", for: .normal)
        authorizationButton.setTitleColor(UIColor.white, for: .normal)
        authorizationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        authorizationButton.backgroundColor = .green
        authorizationButton.layer.borderColor = UIColor.black.cgColor
        authorizationButton.layer.borderWidth = 1
        authorizationButton.layer.cornerRadius = 10
        authorizationButton.layer.shadowColor = UIColor.black.cgColor
        authorizationButton.layer.shadowOpacity = 0.3
        authorizationButton.layer.shadowRadius = 4
        
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(imageView)
        view.addSubview(authorizationLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordResetButton)
        view.addSubview(authorizationButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        [imageView, authorizationLabel, emailTextField, passwordTextField,
         passwordResetButton, authorizationButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            authorizationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            authorizationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: authorizationLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordResetButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            passwordResetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150),
            passwordResetButton.heightAnchor.constraint(equalToConstant: 40),
            
            authorizationButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -50),
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            authorizationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            authorizationButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        passwordResetButton.addTarget(self, action: #selector(passwordResetButtonTapped), for: .touchUpInside)
        
        authorizationButton.addTarget(self, action: #selector(authorizationTapped), for: .touchUpInside)
        authorizationButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        authorizationButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func passwordResetButtonTapped() {
        presenter?.didTapPasswordResetButton()
    }
    
    @objc private func authorizationTapped() {
        presenter?.authorizationButtonTapped(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AuthorizationViewProtocol

extension AuthorizationViewController: AuthorizationViewProtocol {
    
    func showValidationError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccessAlert(title: String, message: String, shouldNavigate: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Успех", style: .default) { [weak self] _ in
            if shouldNavigate {
                self?.presenter?.successAlertConfirmed()
            }
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
            authorizationButton.alpha = 0.5
            authorizationButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
            authorizationButton.alpha = 1.0
            authorizationButton.isEnabled = true
        }
    }
    
    func showPasswordResetAlert() {
        let alertController = UIAlertController(
            title: "Сброс пароля",
            message: "Введите ваш email, и мы отправим ссылку для сброса пароля",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        let sendAction = UIAlertAction(title: "Отправить", style: .default) { [weak self] _ in
            guard let email = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !email.isEmpty else {
                self?.showValidationError(message: "Пожалуйста, введите email")
                return
            }
            
            self?.presenter?.resetPassword(email: email)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        
        present(alertController, animated: true)
    }
}
