import Foundation

//MARK: - NewOrderViewProtocol
protocol NewOrderViewProtocol: AnyObject {
    func updateServices(with items: [OrderServiceItem])
    func updateSpecialists(with items: [OrderSpecialistItem])
    func updateButtonState(isEnabled: Bool)
    func showError(_ error: String)
    func showSuccess()
    func showLoading()
    func hideLoading()
}

