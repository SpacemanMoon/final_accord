import Foundation

//MARK: OrdersViewProtocol
protocol OrdersViewProtocol: AnyObject {
    func showOrders(activeOrders: [OrderFirestore], completedOrders: [OrderFirestore])
    func showError(_ error: String)
    func showLoading(_ isLoading: Bool)
    func updateOrderStatus(at index: Int, in section: OrdersSection)
    func endRefreshing()
    func showConfirmationAlert(title: String, message: String, confirmAction: @escaping () -> Void)
}
