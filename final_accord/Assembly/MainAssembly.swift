import UIKit

//MARK: - MainAssembly
final class MainAssembly {
    static func assemble() -> UIViewController {
        let view = MainViewController()
        let service = MainService()
        let router = MainRouter(viewController: view)
        let presenter = MainPresenter(view: view, service: service, router: router)
        
        view.presenter = presenter 
        
        return view
    }
}
