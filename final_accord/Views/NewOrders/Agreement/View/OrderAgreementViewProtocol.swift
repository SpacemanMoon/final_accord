import Foundation
//MARK: - OrderAgreementViewProtocol
protocol OrderAgreementViewProtocol: AnyObject {
    func configure(with service: ServiceFirestoreItem, specialist: SpecialistFirestore)
    func updateDateSlots(with items: [OrderSlotItem])
    func updateTimeSlots(with items: [OrderSlotItem])
    func getProblemDescription() -> String
    func showError(_ error: String)
    func showSuccess()
    func showLoading()
    func hideLoading()
    func showNoAvailableSlots()
    func updateAcceptButton(isEnabled: Bool)
}
