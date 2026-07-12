import UIKit

final class AboutUsRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

// MARK: - AboutUsRouterProtocol

extension AboutUsRouter: AboutUsRouterProtocol {
    
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
