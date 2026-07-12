import Foundation

//MARK: - ReviewViewProtocol
protocol ReviewViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func updateSubmitButtonState(isEnabled: Bool)
    func displayError(_ error: String)
    func showOrderInfo(masterName: String, orderDate: String)
    func updateCharacterCount(current: Int, max: Int)
}
