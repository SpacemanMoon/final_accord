import Foundation

//MARK: - OnboardingPresenterProtocol
protocol OnboardingPresenterProtocol: AnyObject {
    var itemsCount: Int { get }
    func viewDidLoad()
    func item(at index: Int) -> OnboardingItem
    func isLastPage(at index: Int) -> Bool
    func nextButtonTapped()
    func skipButtonTapped()
    func didScrollToPage(_ page: Int)
}
