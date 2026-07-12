import Foundation

//MARK: NewOrderRouterProtoco
protocol NewOrderRouterProtocol: AnyObject {
    func navigateToConfirmationOrder(service: ServiceFirestoreItem, specialist: SpecialistFirestore)
}
