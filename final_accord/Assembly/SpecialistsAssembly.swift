import UIKit

//MARK: - SpecialistsAssembly
final class SpecialistsAssembly {
    static func assemble() -> UIViewController {
        let view = SpecialistsViewController()
        let service = SpecialistsService()
        let router = SpecialistsRouter (viewController: view)
        let presenter = SpecialistsPresenter(view: view, router: router, service: service)
        view.presenter = presenter
        
        return view
    }
}
