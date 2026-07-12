import UIKit

//MARK: - ProfileAssembly
final class ProfileAssembly {
    static func assemble() -> UIViewController {
        let view = ProfileViewController()
        let service = ProfileService()
        let router = ProfileRouter(viewController: view)
        let presenter = ProfilePresenter(view: view, service: service, router: router)
        view.presenter = presenter
        return view
    }
}
