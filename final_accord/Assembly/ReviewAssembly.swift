import UIKit

//MARK: - ReviewAssembly
final class ReviewAssembly {
    static func assemble(order: OrderFirestore) -> UIViewController {
        let view = ReviewViewController()
        let service = ReviewService()
        let router = ReviewRouter(viewController: view)
        let presenter = ReviewPresenter(
            order: order,
            service: service,
            router: router
        )
        view.presenter = presenter // ✅ ВАЖНО!
        presenter.view = view      // ✅ ВАЖНО!
        
        return view
    }
}
