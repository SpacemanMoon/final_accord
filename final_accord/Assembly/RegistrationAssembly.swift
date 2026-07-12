import UIKit

//MARK: - RegistrationAssembly
final class RegistrationAssembly {
    static func assemble() -> UIViewController {
        let view = RegistrationViewController()
        let service = RegistrationService()
        let router = RegistrationRouter(viewController: view)
        let presenter = RegistrationPresenter(router: router, service: service)
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
