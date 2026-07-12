import Foundation

//MARK: OrdersServiceProtocol
protocol OrdersServiceProtocol {
    func fetchMyOrders(completion: @escaping (Result<[OrderFirestore], Error>) -> Void)  // ← Было fetchOrders
    func updateOrderStatus(orderId: String, status: OrderFirestoreStatus, completion: @escaping (Result<Void, Error>) -> Void)
    func checkIfReviewExists(orderId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func returnSlot(date: String, time: String, masterId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
