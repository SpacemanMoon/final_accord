import UIKit

class OrderAgreementRouter {
    weak var viewController: OrderAgreementViewController?
    
    init(viewController: OrderAgreementViewController? = nil) {
        self.viewController = viewController
    }
}

extension OrderAgreementRouter: OrderAgreementRouterProtocol {
    
    func navigateToSuccess() {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.viewController?.showSuccess()
        }
    }
}
