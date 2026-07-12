import Foundation

final class MainPresenter {
    
    // MARK: - Properties
    
    weak var view: MainViewProtocol?
    private let service: MainServiceProtocol
    private let router: MainRouterProtocol
    
    private var cachedPromos: [PromoCellItem] = []
    private var cachedMasters: [RecommendedSpecialistItem] = []
    
    // MARK: - Init
    
    init(view: MainViewProtocol, service: MainServiceProtocol = MainService(), router: MainRouterProtocol) {
        self.view = view
        self.service = service
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func loadDataFromFirebase(isRefresh: Bool) {
        service.fetchPromoCarousel { [weak self] result in
            switch result {
            case .success(let promos):
                let promoItems = self?.processPromoItems(promos) ?? []
                self?.cachedPromos = promoItems
                self?.checkAndDisplayData()
            case .failure(let error):
                self?.view?.displayError(error.localizedDescription)
            }
        }
        
        service.fetchRecommendedMasters { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let masters):
                    let viewModels = masters.map { RecommendedSpecialistItem(from: $0) }
                    self?.cachedMasters = viewModels
                    self?.checkAndDisplayData()
                case .failure(let error):
                    self?.view?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    private func checkAndDisplayData() {
        DispatchQueue.main.async {
            self.view?.displayData(
                promos: self.cachedPromos,
                services: self.service.fetchPopularServices(),
                masters: self.cachedMasters
            )
        }
    }
    
    private func processPromoItems(_ promos: [PromoFirestoreItem]) -> [PromoCellItem] {
        promos
            .filter { $0.isActive }
            .sorted { $0.order < $1.order }
            .map { promo in
                PromoCellItem(
                    id: promo.id,
                    image: promo.imageUrl,
                    order: promo.order,
                    isActive: promo.isActive
                )
            }
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        loadDataFromFirebase(isRefresh: false)
    }
    
    func viewDidPullToRefresh() {
        loadDataFromFirebase(isRefresh: true)
    }
    
    func didSelectItemPopularService() {
        router.navigateToNewOrder()
    }
    
    func didSelectRecommendedMasters(with id: String) {
        router.navigateToSpecialistDetail(with: id)
    }
}
