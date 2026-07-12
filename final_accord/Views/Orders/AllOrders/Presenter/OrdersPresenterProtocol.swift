import Foundation

//MARK: OrdersPresenterProtocol
protocol OrdersPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func refreshOrders()
    func getOrders(for segment: Int) -> [OrderFirestore]
    func getOrderAction(_ order: OrderFirestore) -> OrderAction?
    func shouldShowReviewButton(for order: OrderFirestore) -> Bool
    func didTapActionButton(on order: OrderFirestore, at index: Int, in section: OrdersSection)
    func didTapReviewButton(on order: OrderFirestore)
}
