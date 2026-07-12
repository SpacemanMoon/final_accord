import UIKit

// MARK: - AboutUsAssembler
final class AboutUsAssembler {
    static func assemble() -> AboutUsViewController {
        let viewController = AboutUsViewController()
        let router = AboutUsRouter(viewController: viewController)
        let service = AboutUsService()
        let presenter = AboutUsPresenter(view: viewController,
                                         router: router,
                                         service: service)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
