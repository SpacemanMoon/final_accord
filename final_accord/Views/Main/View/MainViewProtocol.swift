import Foundation

//MARK: MainVIewProtocol
protocol MainViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayData(promos: [PromoCellItem], services: [PopularServicesItem], masters: [RecommendedSpecialistItem])
    func displayError(_ message: String)
}
