import Foundation

//MARK: - OrderAgreementPresenterProtocol
protocol OrderAgreementPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapAcceptOrder(with description: String)
    func didSelectDate(at index: Int)
    func didSelectTime(at index: Int)
    func textViewDidChange(_ text: String)
}
