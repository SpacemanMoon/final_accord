import Foundation

//MARK: - OrderAgreementServiceProtocol
protocol OrderAgreementServiceProtocol {
    func fetchAvailableSlots(for specialistId: String, completion: @escaping (Result<[String: [String]], Error>) -> Void)
    func saveOrder(_ order: OrderFirestore, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchOrders(for masterId: String, completion: @escaping (Result<[OrderFirestore], Error>) -> Void)
    func updateOrderStatus(orderId: String, status: OrderFirestoreStatus, completion: @escaping (Result<Void, Error>) -> Void)
    func returnSlot(date: String, time: String, masterId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getClientId() -> String?
    func getUserName(completion: @escaping (String) -> Void)
    func getUserPhone(completion: @escaping (String) -> Void)
    func getUserAddress(completion: @escaping (String) -> Void)
}
