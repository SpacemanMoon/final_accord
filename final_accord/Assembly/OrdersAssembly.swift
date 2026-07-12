import UIKit

//MARK: - OrdersAssembly
final class OrdersAssembly {
    static func assemble() -> UIViewController {
        let view = OrdersViewController()
        let service = OrdersService()
        let router = OrdersRouter(viewController: view)
        let presenter = OrdersPresenter(view: view, service: service, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
