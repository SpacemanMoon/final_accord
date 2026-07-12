import UIKit

//MARK: - AuthorizationAssembly
final class AuthorizationAssembly {
    static func assemble() -> UIViewController {
        let view = AuthorizationViewController()
        let service = AuthorizationService()
        let router = AuthorizationRouter(viewController: view)
        let presenter = AuthorizationPresenter(router: router, service: service)
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
