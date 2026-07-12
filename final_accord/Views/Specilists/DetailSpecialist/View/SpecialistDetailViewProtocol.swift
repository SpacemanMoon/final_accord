import Foundation

//MARK: SpecialistDetailViewProtocol
protocol SpecialistDetailViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSpecialist(_ specialist: SpecialistItem)
}
