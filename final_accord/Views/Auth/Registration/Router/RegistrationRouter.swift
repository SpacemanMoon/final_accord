import UIKit

final class RegistrationRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationRouterProtocol

extension RegistrationRouter: RegistrationRouterProtocol {
    
    func navigateToLogin() {
        let authorizationVC = AuthorizationAssembly.assemble()
        if let navigationController = viewController?.navigationController {
            navigationController.pushViewController(authorizationVC, animated: true)
        } else {
            authorizationVC.modalPresentationStyle = .automatic
            viewController?.present(authorizationVC, animated: true)
        }
    }
    
    func navigateToMainApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = delegate.window else {
            return
        }
        
        let mainTabBarVC = TabBarViewController()
        
        UIView.transition(with: window!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = mainTabBarVC
        }, completion: nil)
    }
}
