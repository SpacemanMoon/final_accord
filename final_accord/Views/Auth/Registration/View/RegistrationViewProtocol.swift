protocol RegistrationViewProtocol: AnyObject {
    func showValidationError(message: String)
    func showSuccessAlert(title: String, message: String)
    func setLoading(_ isLoading: Bool)
}
