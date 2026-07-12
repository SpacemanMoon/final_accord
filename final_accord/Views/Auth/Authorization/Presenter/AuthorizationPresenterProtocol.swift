import Foundation

//MARK: - AuthorizationPresenterProtocol
protocol AuthorizationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func authorizationButtonTapped(email: String?, password: String?)
    func successAlertConfirmed()
    func didTapPasswordResetButton()
    func resetPassword(email: String)
}
