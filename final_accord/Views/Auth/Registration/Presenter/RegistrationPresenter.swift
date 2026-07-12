import Foundation

final class RegistrationPresenter {
    
    // MARK: - Properties
    
    weak var view: RegistrationViewProtocol?
    
    private let router: RegistrationRouterProtocol
    private let service: RegistrationServiceProtocol
    private let validator = RegistrationValidator()
    
    // MARK: - Init
    
    init(router: RegistrationRouterProtocol, service: RegistrationServiceProtocol) {
        self.router = router
        self.service = service
    }
    
    // MARK: - Private Methods
    
    private func registerUser(
        name: String,
        lastName: String,
        phone: String,
        email: String,
        password: String
    ) {
        service.registerUser(
            name: name,
            lastName: lastName,
            phone: phone,
            email: email,
            password: password
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.setLoading(false)
                
                switch result {
                case .success:
                    self.view?.showSuccessAlert(
                        title: "Успех!",
                        message: "Регистрация прошла успешно. Добро пожаловать!"
                    )
                    
                case .failure(let error):
                    let errorMessage = AuthErrorHandler.description(for: error)
                    self.view?.showValidationError(message: errorMessage)
                }
            }
        }
    }
}

// MARK: - RegistrationPresenterProtocol

extension RegistrationPresenter: RegistrationPresenterProtocol {
    
    func viewDidLoad() {}
    
    func registrationButtonTapped(
        name: String?,
        lastName: String?,
        email: String?,
        phone: String?,
        password: String?,
        confirmPassword: String?
    ) {
        let formattedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formattedPhone = phone?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let error = validator.validateName(name) {
            view?.showValidationError(message: error)
            return
        }
        
        if let error = validator.validateLastName(lastName) {
            view?.showValidationError(message: error)
            return
        }
        
        if let error = validator.validateEmail(formattedEmail) {
            view?.showValidationError(message: error)
            return
        }
        
        if let error = validator.validatePhone(formattedPhone) {
            view?.showValidationError(message: error)
            return
        }
        
        if let error = validator.validatePassword(password) {
            view?.showValidationError(message: error)
            return
        }
        
        if let error = validator.validateConfirmPassword(password, confirm: confirmPassword) {
            view?.showValidationError(message: error)
            return
        }
        
        view?.setLoading(true)
        
        service.checkIfUserExists(
            email: formattedEmail!,
            phone: formattedPhone!
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let exists):
                    if exists {
                        self.view?.setLoading(false)
                        self.view?.showValidationError(
                            message: "Пользователь с таким email или телефоном уже зарегистрирован"
                        )
                    } else {
                        self.registerUser(
                            name: name!,
                            lastName: lastName!,
                            phone: formattedPhone!,
                            email: formattedEmail!,
                            password: password!
                        )
                    }
                    
                case .failure(let error):
                    self.view?.setLoading(false)
                    let errorMessage = AuthErrorHandler.description(for: error)
                    self.view?.showValidationError(message: errorMessage)
                }
            }
        }
    }
    
    func authorizationButtonTapped() {
        router.navigateToLogin()
    }
    
    func successAlertConfirmed() {
        router.navigateToMainApp()
    }
}
