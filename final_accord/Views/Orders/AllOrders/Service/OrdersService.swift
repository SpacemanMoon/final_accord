import Foundation
import FirebaseAuth

final class OrdersService {
    
    // MARK: - Properties
    
    private let dbManager = FirestoreDatabaseManager.shared
}

// MARK: - OrdersServiceProtocol

extension OrdersService: OrdersServiceProtocol {
    
    func fetchMyOrders(completion: @escaping (Result<[OrderFirestore], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(
                domain: "OrdersService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
            completion(.failure(error))
            return
        }
        
        dbManager.fetchFilteredCollectionExact(
            collection: "orders",
            field: "clientId",
            isEqualTo: userId,
            completion: completion
        )
    }
    
    func updateOrderStatus(orderId: String, status: OrderFirestoreStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(
                domain: "OrdersService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
            completion(.failure(error))
            return
        }
        
        dbManager.fetchDocument(collection: "orders", docId: orderId) { (result: Result<OrderFirestore, Error>) in
            switch result {
            case .success(let order):
                guard order.clientId == userId else {
                    let error = NSError(
                        domain: "OrdersService",
                        code: -2,
                        userInfo: [NSLocalizedDescriptionKey: "Нет прав для изменения этого заказа"]
                    )
                    completion(.failure(error))
                    return
                }
                
                let data: [String: Any] = ["status": status.rawValue]
                self.dbManager.updateDocument(
                    collection: "orders",
                    docId: orderId,
                    data: data,
                    completion: completion
                )
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkIfReviewExists(orderId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        dbManager.fetchFilteredCollectionExact(
            collection: "reviews",
            field: "orderId",
            isEqualTo: orderId
        ) { (result: Result<[ReviewFirestore], Error>) in
            switch result {
            case .success(let reviews):
                completion(.success(!reviews.isEmpty))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func returnSlot(date: String, time: String, masterId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let slotId = "\(masterId)_\(date)_\(time)"
        dbManager.deleteDocument(collection: "booked_slots", docId: slotId, completion: completion)
    }
}
