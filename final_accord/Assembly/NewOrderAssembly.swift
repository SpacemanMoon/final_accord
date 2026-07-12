import UIKit

//MARK: - NewOrderAssembly
final class NewOrderAssembly {
    static func assemble() -> UIViewController {
        let view = NewOrderViewController()
        let service = NewOrderService()
        let router = NewOrderRouter(viewController: view)
        let presenter = NewOrderPresenter(view: view, service: service, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
