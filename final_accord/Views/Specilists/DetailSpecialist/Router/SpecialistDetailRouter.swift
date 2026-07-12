import UIKit

final class SpecialistDetailRouter {
    
    // MARK: - Properties
    
    weak var viewController: SpecialistDetailViewController?
    
    // MARK: - Init
    
    init(viewController: SpecialistDetailViewController) {
        self.viewController = viewController
    }
}

// MARK: - SpecialistDetailRouterProtocol

extension SpecialistDetailRouter: SpecialistDetailRouterProtocol {
    
    func navigateTo() {
        //TODO: Сделать полный список отзывов
    }
}
