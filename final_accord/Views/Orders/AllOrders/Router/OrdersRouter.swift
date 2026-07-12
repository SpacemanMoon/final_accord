import UIKit

final class OrdersRouter {
    
    // MARK: - Properties
    
    weak var viewController: OrdersViewController?
    
    // MARK: - Init
    
    init(viewController: OrdersViewController) {
        self.viewController = viewController
    }
}

// MARK: - OrdersRouterProtocol

extension OrdersRouter: OrdersRouterProtocol {
    
    func navigateToReview(order: OrderFirestore) {
        let reviewVC = ReviewAssembly.assemble(order: order)
        viewController?.navigationController?.pushViewController(reviewVC, animated: true)
    }
}
