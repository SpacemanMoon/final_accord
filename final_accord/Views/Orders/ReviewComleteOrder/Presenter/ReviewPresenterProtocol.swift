import Foundation
//MARK: - ReviewPresenterProtocol
protocol ReviewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectRating(_ rating: Int)
    func didChangeComment(_ text: String)
    func didTapSendReview(comment: String)
}
