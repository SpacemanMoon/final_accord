import Foundation

final class ReviewPresenter {
    
    // MARK: - Properties
    
    weak var view: ReviewViewProtocol?
    private let order: OrderFirestore
    private let service: ReviewServiceProtocol
    private let router: ReviewRouterProtocol
    private var isLoading = false
    private var selectedRating: Int = 0
    private var comment: String = ""
    private let maxCharacterCount = 150
    
    // MARK: - Init
    
    init(order: OrderFirestore, service: ReviewServiceProtocol, router: ReviewRouterProtocol) {
        self.order = order
        self.service = service
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy  HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func updateSubmitButtonState() {
        let isEnabled = selectedRating > 0 && !comment.isEmpty && comment.count <= maxCharacterCount
        view?.updateSubmitButtonState(isEnabled: isEnabled)
    }
    
    private func updateCharacterCount() {
        view?.updateCharacterCount(current: comment.count, max: maxCharacterCount)
    }
}

// MARK: - ReviewPresenterProtocol

extension ReviewPresenter: ReviewPresenterProtocol {
    
    func viewDidLoad() {
        let formattedDate = formatDate(order.dateTime)
        let masterName = order.masterName
        view?.showOrderInfo(masterName: masterName, orderDate: formattedDate)
        updateSubmitButtonState()
        updateCharacterCount()
    }
    
    func didSelectRating(_ rating: Int) {
        selectedRating = rating
        updateSubmitButtonState()
    }
    
    func didChangeComment(_ text: String) {
        if text.count > maxCharacterCount {
            let trimmed = String(text.prefix(maxCharacterCount))
            comment = trimmed
            view?.updateCharacterCount(current: trimmed.count, max: maxCharacterCount)
            view?.updateSubmitButtonState(isEnabled: selectedRating > 0 && !trimmed.isEmpty)
            return
        }
        
        comment = text
        updateCharacterCount()
        updateSubmitButtonState()
    }
    
    func didTapSendReview(comment: String) {
        guard !isLoading else {
            return
        }
        guard selectedRating > 0 else {
            view?.displayError("Пожалуйста, выберите оценку")
            return
        }
        guard !comment.isEmpty else {
            view?.displayError("Пожалуйста, напишите отзыв")
            return
        }
        
        isLoading = true
        view?.showLoading()
        
        service.submitReview(order: order, rating: selectedRating, comment: comment) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.view?.hideLoading()
                
                switch result {
                case .success:
                    self?.router.showSuccessAndDismiss()
                case .failure(let error):
                    self?.view?.displayError(error.localizedDescription)
                }
            }
        }
    }
}
