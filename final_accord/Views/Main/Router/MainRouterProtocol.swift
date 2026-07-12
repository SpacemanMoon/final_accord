import Foundation

//MARK: MainRouterProtocol
protocol MainRouterProtocol: AnyObject {
    func navigateToNewOrder()
    func navigateToSpecialistDetail(with masterId: String)
}
