import UIKit

final class ReviewRouter {
    
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Private Methods
    
    internal func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        })
        viewController?.present(alert, animated: true)
    }
}

// MARK: - ReviewRouterProtocol

extension ReviewRouter: ReviewRouterProtocol {
    
    func showError(_ message: String) {
        showAlert(title: "Ошибка", message: message)
    }
    
    func showSuccessAndDismiss() {
        showAlert(title: "Спасибо!", message: "Ваш отзыв успешно отправлен") { [weak self] in
            self?.dismiss()
        }
    }
}
