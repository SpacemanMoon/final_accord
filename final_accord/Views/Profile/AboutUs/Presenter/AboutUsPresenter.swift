import Foundation

final class AboutUsPresenter {
    
    // MARK: - Properties
    
    weak var view: AboutUsViewProtocol?
    private let router: AboutUsRouterProtocol
    private let service: AboutUsServiceProtocol
    
    // MARK: - Init
    
    init(view: AboutUsViewProtocol,
         router: AboutUsRouterProtocol,
         service: AboutUsServiceProtocol) {
        self.view = view
        self.router = router
        self.service = service
    }
    
    // MARK: - Private Methods
    
    private func loadAboutData() {
        view?.showLoading()
        
        service.fetchAboutData { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                
                switch result {
                case .success(let data):
                    self?.view?.displayAboutData(data)
                case .failure(let error):
                    self?.view?.displayError(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - AboutUsPresenterProtocol

extension AboutUsPresenter: AboutUsPresenterProtocol {
    
    func viewDidLoad() {
        loadAboutData()
    }
    
    func didTapBackButton() {
        router.navigateBack()
    }
}
