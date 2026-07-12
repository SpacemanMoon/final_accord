import UIKit

final class ProfileRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Private Methods
    
    private func pushViewController(_ viewController: UIViewController) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ProfileRouterProtocol

extension ProfileRouter: ProfileRouterProtocol {
    
    func navigateToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = delegate.window else {
            return
        }
        
        let regVC = RegistrationAssembly.assemble()
        
        UIView.transition(with: window!, duration: 0.4, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = regVC
        }, completion: nil)
    }
    
    func navigateToAllOrders() {
        let ordersViewController = OrdersAssembly.assemble()
        pushViewController(ordersViewController)
    }
    
    func navigateToAboutCompany() {
        let aboutVC = AboutUsAssembler.assemble()
        pushViewController(aboutVC)
    }
}
