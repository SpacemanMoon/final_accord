import UIKit

final class AuthorizationRouter {
    
    // MARK: - Properties
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - AuthorizationRouterProtocol
extension AuthorizationRouter: AuthorizationRouterProtocol {
    
    func navigateToMainApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = delegate.window else { return }
        
        let mainTabBarVC = TabBarViewController()
        
        UIView.transition(with: window!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = mainTabBarVC
        }, completion: nil)
    }
}
