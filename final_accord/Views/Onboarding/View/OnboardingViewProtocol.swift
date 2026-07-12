import Foundation

//MARK: - OnboardingViewProtocol
protocol OnboardingViewProtocol: AnyObject {
    func scrollToItem(at index: Int)
    func reloadData()
    func updateUI(page: Int, totalPages: Int, isLastPage: Bool)
}
