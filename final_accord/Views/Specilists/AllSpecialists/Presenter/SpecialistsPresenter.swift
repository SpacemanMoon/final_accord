import Foundation

final class SpecialistsPresenter {
    
    // MARK: - Properties
    
    weak var view: SpecialistsViewProtocol?
    private let router: SpecialistsRouterProtocol
    private let service: SpecialistsServiceProtocol
    
    private var specialists: [SpecialistItem] = []
    
    // MARK: - Init
    
    init(view: SpecialistsViewProtocol,
         router: SpecialistsRouterProtocol,
         service: SpecialistsServiceProtocol) {
        self.view = view
        self.router = router
        self.service = service
    }
    
    // MARK: - Public Methods
    
    func fetchSpecialists() {
        service.fetchMasters { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let specialists):
                    self?.specialists = specialists
                    self?.view?.hideLoading()
                    self?.view?.showSpecialists(specialists)
                case .failure(let error):
                    self?.view?.hideLoading()
                    self?.view?.showError(error)
                }
            }
        }
    }
}

// MARK: - SpecialistsPresenterProtocol

extension SpecialistsPresenter: SpecialistsPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        fetchSpecialists()
    }
    
    func didSelectSpecialist(at index: Int) {
        guard index < specialists.count else { return }
        let specialist = specialists[index]
        router.navigateToDetailSpecialist(with: specialist.id)
    }
}
