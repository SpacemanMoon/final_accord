import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - Private UIComponents
    
    private let imageView = UIImageView()
    private let registrationLabel = UILabel()
    private let nameTextField = CustomTextField()
    private let lastNameTextField = CustomTextField()
    private let emailTextField = CustomTextField()
    private let phoneTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let confirmPasswordTextField = CustomTextField()
    private let registrationButton = UIButton()
    private let authorizationButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    var presenter: RegistrationPresenterProtocol?
    private var activeTextField: UITextField?
    private var bottomConstraint: NSLayoutConstraint?
    private let originalBottomConstant: CGFloat = -20
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupKeyboardDismissGesture()
        registerForKeyboardNotifications()
        presenter?.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView.image = UIImage(named: "backgroundReg")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.75
        imageView.isUserInteractionEnabled = true
        
        registrationLabel.text = "Регистрация"
        registrationLabel.font = UIFont.boldSystemFont(ofSize: 30)
        registrationLabel.textColor = .black
        registrationLabel.layer.shadowColor = UIColor.black.cgColor
        registrationLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        registrationLabel.layer.shadowRadius = 4
        
        nameTextField.configure(with: .firstName)
        nameTextField.delegate = self
        lastNameTextField.configure(with: .lastName)
        lastNameTextField.delegate = self
        emailTextField.configure(with: .email)
        emailTextField.delegate = self
        phoneTextField.configure(with: .phone)
        phoneTextField.delegate = self
        passwordTextField.configure(with: .password)
        passwordTextField.delegate = self
        confirmPasswordTextField.configure(with: .confirmPassword)
        confirmPasswordTextField.delegate = self
        
        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.setTitleColor(UIColor.white, for: .normal)
        registrationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        registrationButton.backgroundColor = .green
        registrationButton.layer.borderColor = UIColor.black.cgColor
        registrationButton.layer.borderWidth = 1
        registrationButton.layer.cornerRadius = 10
        registrationButton.layer.shadowColor = UIColor.black.cgColor
        registrationButton.layer.shadowOpacity = 0.3
        registrationButton.layer.shadowRadius = 4
        
        authorizationButton.setTitle("Уже есть аккаунт? Войти", for: .normal)
        authorizationButton.setTitleColor(UIColor.white, for: .normal)
        authorizationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        authorizationButton.layer.cornerRadius = 10
        authorizationButton.layer.shadowColor = UIColor.black.cgColor
        authorizationButton.layer.shadowOpacity = 0.3
        authorizationButton.layer.shadowRadius = 4
        
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(imageView)
        view.addSubview(registrationLabel)
        view.addSubview(nameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registrationButton)
        view.addSubview(authorizationButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        [imageView, registrationLabel, nameTextField, lastNameTextField,
         emailTextField, phoneTextField, passwordTextField,
         confirmPasswordTextField, registrationButton,
         authorizationButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bottomConstraint = authorizationButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: originalBottomConstant
        )
        
        guard let bottomConstraint = bottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            registrationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            registrationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            nameTextField.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            lastNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationButton.widthAnchor.constraint(equalToConstant: 250),
            authorizationButton.heightAnchor.constraint(equalToConstant: 30),
            bottomConstraint,
            
            registrationButton.bottomAnchor.constraint(equalTo: authorizationButton.topAnchor, constant: -20),
            registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        registrationButton.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        authorizationButton.addTarget(self, action: #selector(authorizationTapped), for: .touchUpInside)
        
        registrationButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        authorizationButton.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        
        let releaseEvents: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel]
        registrationButton.addTarget(self, action: #selector(buttonReleased), for: releaseEvents)
        authorizationButton.addTarget(self, action: #selector(buttonReleased), for: releaseEvents)
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Keyboard
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let bottomConstraint = bottomConstraint else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        let newConstant = -keyboardHeight + safeAreaBottom + authorizationButton.frame.height
        view.frame.origin.y = -registrationLabel.frame.height - nameTextField.frame.height
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve)
        ) {
            bottomConstraint.constant = newConstant
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let bottomConstraint = bottomConstraint else {
            return
        }
        view.frame.origin.y = 0
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve)
        ) {
            bottomConstraint.constant = self.originalBottomConstant
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func registrationButtonTapped() {
        view.endEditing(true)
        presenter?.registrationButtonTapped(
            name: nameTextField.text,
            lastName: lastNameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text
        )
    }
    
    @objc private func authorizationTapped() {
        presenter?.authorizationButtonTapped()
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

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        UIView.animate(withDuration: 0.2) {
            textField.layer.shadowColor = UIColor.systemBlue.cgColor
            textField.layer.shadowRadius = 8
            textField.layer.shadowOpacity = 0.3
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
        UIView.animate(withDuration: 0.2) {
            textField.layer.shadowColor = UIColor.clear.cgColor
            textField.layer.shadowRadius = 0
            textField.layer.shadowOpacity = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [nameTextField, lastNameTextField, emailTextField, phoneTextField, passwordTextField, confirmPasswordTextField]
        if let index = textFields.firstIndex(where: { $0 === textField }),
           index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - RegistrationViewProtocol

extension RegistrationViewController: RegistrationViewProtocol {
    
    func showValidationError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccessAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Отлично", style: .default) { [weak self] _ in
            self?.presenter?.successAlertConfirmed()
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
            registrationButton.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
            registrationButton.alpha = 1.0
        }
    }
}
