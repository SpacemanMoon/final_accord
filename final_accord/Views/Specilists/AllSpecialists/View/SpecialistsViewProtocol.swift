import Foundation

//MARK: SpecialistsViewProtocol
protocol SpecialistsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showSpecialists(_ specialists: [SpecialistItem])
    func showError(_ error: Error)
}
