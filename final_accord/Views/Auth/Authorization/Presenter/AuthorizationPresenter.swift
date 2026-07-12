import Foundation

final class AuthorizationPresenter {
    
    // MARK: - Properties
    
    weak var view: AuthorizationViewProtocol?
    
    private let router: AuthorizationRouterProtocol
    private let service: AuthorizationServiceProtocol
    
    // MARK: - Init
    
    init(router: AuthorizationRouterProtocol, service: AuthorizationServiceProtocol) {
        self.router = router
        self.service = service
    }
    
    // MARK: - Private Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - AuthorizationPresenterProtocol

extension AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    func viewDidLoad() {}
    
    func didTapPasswordResetButton() {
        view?.showPasswordResetAlert()
    }
    
    func resetPassword(email: String) {
        view?.setLoading(true)
        
        service.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.setLoading(false)
            }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.view?.showSuccessAlert(
                        title: "Письмо отправлено!",
                        message: "Ссылка для сброса пароля отправлена на ваш email. Проверьте почту.",
                        shouldNavigate: false
                    )
                }
                
            case .failure(let error):
                let errorMessage = AuthErrorHandler.description(for: error)
                DispatchQueue.main.async {
                    self.view?.showValidationError(message: errorMessage)
                }
            }
        }
    }
    
    func authorizationButtonTapped(email: String?, password: String?) {
        let formattedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let email = formattedEmail, !email.isEmpty,
            let password = password, !password.isEmpty else {
            view?.showValidationError(message: "Заполните все поля")
            return
        }
        
        guard isValidEmail(email) else {
            view?.showValidationError(message: "Некорректный формат email")
            return
        }
        
        let strongView = self.view
        
        DispatchQueue.main.async {
            strongView?.setLoading(true)
        }
        
        service.loginUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            let strongView = self.view
            
            DispatchQueue.main.async {
                strongView?.setLoading(false)
            }
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    strongView?.showSuccessAlert(
                        title: "Успех!",
                        message: "Авторизация прошла успешно.",
                        shouldNavigate: true
                    )
                }
                
            case .failure(let error):
                let errorMessage = AuthErrorHandler.description(for: error)
                
                DispatchQueue.main.async {
                    strongView?.showValidationError(message: errorMessage)
                }
            }
        }
    }
    
    func successAlertConfirmed() {
        router.navigateToMainApp()
    }
}
