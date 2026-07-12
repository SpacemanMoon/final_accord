import Foundation

final class OnboardingPresenter {
    
    // MARK: - Properties
    
    weak var view: OnboardingViewProtocol?
    
    private let router: OnboardingRouterProtocol
    private let service: OnboardingServiceProtocol
    
    private var items: [OnboardingItem] = []
    private var currentIndex = 0
    
    // MARK: - Init
    
    init(router: OnboardingRouterProtocol, service: OnboardingServiceProtocol) {
        self.router = router
        self.service = service
    }
    
    // MARK: - Private Methods
    
    private func updateView() {
        view?.updateUI(
            page: currentIndex,
            totalPages: items.count,
            isLastPage: currentIndex == items.count - 1
        )
    }
    
    private func finish() {
        service.setOnboardingSeen()
        router.navigateToRegistration()
    }
}

// MARK: - OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    
    var itemsCount: Int {
        return items.count
    }
    
    func viewDidLoad() {
        items = service.fetchOnboardingItems()
        view?.reloadData()
        updateView()
    }
    
    func item(at index: Int) -> OnboardingItem {
        return items[index]
    }
    
    func isLastPage(at index: Int) -> Bool {
        return index == items.count - 1
    }
    
    func nextButtonTapped() {
        if currentIndex < items.count - 1 {
            currentIndex += 1
            view?.scrollToItem(at: currentIndex)
            updateView()
        } else {
            finish()
        }
    }
    
    func skipButtonTapped() {
        finish()
    }
    
    func didScrollToPage(_ page: Int) {
        currentIndex = page
        updateView()
    }
}
