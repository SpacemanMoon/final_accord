import Foundation


//MARK: - RegistrationPresenterProtocol
protocol RegistrationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func registrationButtonTapped(
        name: String?,
        lastName: String?,
        email: String?,
        phone: String?,
        password: String?,
        confirmPassword: String?
    )
    func authorizationButtonTapped()
    func successAlertConfirmed()
}
