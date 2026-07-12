import UIKit

//MARK: - SpecialistDetailAssembly
final class SpecialistDetailAssembly {
    static func assemble(with masterId: String) -> SpecialistDetailViewController {
        let viewController = SpecialistDetailViewController()
        let service = SpecialistDetailService()
        let router = SpecialistDetailRouter(viewController: viewController)
        let presenter = SpecialistDetailPresenter(
            view: viewController,
            router: router,
            service: service,
            specialistId: masterId
        )
        viewController.presenter = presenter
        
        return viewController
    }
}
