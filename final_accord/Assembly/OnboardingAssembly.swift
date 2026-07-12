import UIKit

//MARK: - OnboardingAssembly
final class OnboardingAssembly {
    static func assemble() -> UIViewController {
        let view = OnboardingViewController()
        let router = OnboardingRouter(viewController: view)
        let service = OnboardingService()
        let presenter = OnboardingPresenter(router: router, service: service)
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
