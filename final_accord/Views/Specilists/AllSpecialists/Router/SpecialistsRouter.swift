import UIKit

class SpecialistsRouter {
    weak var viewController: SpecialistsViewController?
    
    init(viewController: SpecialistsViewController? = nil) {
        self.viewController = viewController
    }
}

//MARK: - SpecialistsRouter: SpecialistsRouterProtocol 
extension SpecialistsRouter: SpecialistsRouterProtocol {
    func navigateToDetailSpecialist(with specialistId: String) { // Принимает ID
        let detailVC = SpecialistDetailAssembly.assemble(with: specialistId) // Передаем ID
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
