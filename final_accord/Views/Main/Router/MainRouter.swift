import UIKit

class MainRouter {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

//MARK: - MainRouter:MainRouterProtocol
extension MainRouter: MainRouterProtocol {
    func navigateToNewOrder() {
        let vc = NewOrderAssembly.assemble()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSpecialistDetail(with masterId: String) {
        let detailVC = SpecialistDetailAssembly.assemble(with: masterId)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
