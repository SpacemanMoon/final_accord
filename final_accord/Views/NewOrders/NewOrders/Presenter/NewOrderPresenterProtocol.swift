import Foundation

//MARK: - NewOrderPresenterProtocol
protocol NewOrderPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectService(at index: Int)
    func didSelectSpecialist(at index: Int)
    func didTapCreateOrder()
    func isServiceSelected(at index: Int) -> Bool
    func isSpecialistSelected(at index: Int) -> Bool
}
