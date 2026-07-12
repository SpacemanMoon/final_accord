import UIKit

class NewOrderRouter {
    weak var viewController: NewOrderViewController?
    
    init(viewController: NewOrderViewController? = nil) {
        self.viewController = viewController
    }
}

//MARK: - NewOrderRouter: NewOrderRouterProtocol
extension NewOrderRouter: NewOrderRouterProtocol {
    func navigateToConfirmationOrder(service: ServiceFirestoreItem, specialist: SpecialistFirestore) {
        let confirmationViewController = OrderAgreementViewController()
        let confirmationPresenter = OrderAgreementPresenter(
            view: confirmationViewController,
            service: OrderAgreementService(),
            router: OrderAgreementRouter(viewController: confirmationViewController),
            serviceItem: service,
            specialist: specialist,
            profileService: ProfileService()
        )
        confirmationViewController.presenter = confirmationPresenter
        
        let navigationController = UINavigationController(rootViewController: confirmationViewController)
        viewController?.present(navigationController, animated: true)
    }
}
