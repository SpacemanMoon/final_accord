import UIKit

final class OnboardingRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - OnboardingRouterProtocol

extension OnboardingRouter: OnboardingRouterProtocol {
    
    func navigateToRegistration() {
        let registrationVC = RegistrationAssembly.assemble()
        registrationVC.modalPresentationStyle = .fullScreen
        registrationVC.modalTransitionStyle = .crossDissolve
        viewController?.present(registrationVC, animated: true)
    }
}
