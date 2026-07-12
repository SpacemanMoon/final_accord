import Foundation

final class SpecialistDetailPresenter {
    
    // MARK: - Properties
    
    weak var view: SpecialistDetailViewProtocol?
    private let router: SpecialistDetailRouterProtocol
    private let service: SpecialistDetailServiceProtocol
    private let specialistId: String
    
    // MARK: - Init
    
    init(view: SpecialistDetailViewProtocol,
         router: SpecialistDetailRouterProtocol,
         service: SpecialistDetailServiceProtocol,
         specialistId: String) {
        self.view = view
        self.router = router
        self.service = service
        self.specialistId = specialistId
    }
    
    // MARK: - Private Methods
    
    private func fetchSpecialistDetails() {
        service.fetchSpecialistDetails(id: specialistId) { [weak self] (result: Result<SpecialistItem, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let specialist):
                    self?.view?.hideLoading()
                    self?.view?.showSpecialist(specialist)
                case .failure(let error):
                    self?.view?.hideLoading()
                    self?.view?.showError("Ошибка: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - SpecialistDetailPresenterProtocol

extension SpecialistDetailPresenter: SpecialistDetailPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        fetchSpecialistDetails()
    }
}
