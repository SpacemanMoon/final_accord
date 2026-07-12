import Foundation

//MARK: - AuthorizationViewProtocol
protocol AuthorizationViewProtocol: AnyObject {
    func showValidationError(message: String)
    func showSuccessAlert(title: String, message: String, shouldNavigate: Bool)
    func setLoading(_ isLoading: Bool)
    func showPasswordResetAlert()
}
