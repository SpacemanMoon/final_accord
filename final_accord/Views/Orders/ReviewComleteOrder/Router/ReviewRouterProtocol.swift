import Foundation

//MARK: - ReviewRouterProtocol
protocol ReviewRouterProtocol: AnyObject {
    func dismiss()
    func showError(_ message: String)
    func showSuccessAndDismiss()
}
