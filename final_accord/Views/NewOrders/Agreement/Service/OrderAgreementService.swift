import Foundation
import FirebaseFirestore

final class OrderAgreementService {
    
    // MARK: - Properties
    
    private let dbManager: FirestoreDatabaseManagerProtocol
    private let sessionService = UserSessionService.shared
    
    // MARK: - Init
    
    init(dbManager: FirestoreDatabaseManagerProtocol = FirestoreDatabaseManager.shared) {
        self.dbManager = dbManager
    }
    
    // MARK: - Private Methods
    
    private func generateSlots(from specialist: SpecialistFirestore) -> [String: [String]] {
        var slots: [String: [String]] = [:]
        
        let calendar = Calendar.current
        let today = Date()
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: today) else { continue }
            
            let weekday = calendar.component(.weekday, from: date)
            
            if specialist.workingDays.contains(weekday) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: date)
                
                let timeSlots = specialist.workingHours.map { "\($0):00" }
                slots[dateString] = timeSlots
            }
        }
        return slots
    }
}

// MARK: - OrderAgreementServiceProtocol

extension OrderAgreementService: OrderAgreementServiceProtocol {
    func fetchAvailableSlots(for specialistId: String, completion: @escaping (Result<[String: [String]], Error>) -> Void) {
        dbManager.fetchDocument(collection: "specialists", docId: specialistId) { (result: Result<SpecialistFirestore, Error>) in
            switch result {
            case .success(let specialist):
                let slots = self.generateSlots(from: specialist)
                completion(.success(slots))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveOrder(_ order: OrderFirestore, completion: @escaping (Result<Void, Error>) -> Void) {
        dbManager.saveDocument(
            collection: "orders",
            docId: order.id,
            item: order
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOrders(for masterId: String, completion: @escaping (Result<[OrderFirestore], Error>) -> Void) {
        dbManager.fetchFilteredCollectionExact(
            collection: "orders",
            field: "masterId",
            isEqualTo: masterId
        ) { (result: Result<[OrderFirestore], Error>) in
            completion(result)
        }
    }
    
    func updateOrderStatus(orderId: String, status: OrderFirestoreStatus, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = ["status": status.rawValue]
        dbManager.updateDocument(collection: "orders", docId: orderId, data: data) { result in
            completion(result)
        }
    }
    
    func returnSlot(date: String, time: String, masterId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let slotId = "\(masterId)_\(date)_\(time)"
        
        dbManager.deleteDocument(collection: "booked_slots", docId: slotId) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getClientId() -> String? {
        return sessionService.currentUserID
    }
    
    func getUserName(completion: @escaping (String) -> Void) {
        guard let clientId = getClientId() else {
            completion("Noname Noname")
            return
        }
        
        dbManager.fetchDocument(collection: "client", docId: clientId) { (result: Result<ClientFirestore, Error>) in
            switch result {
            case .success(let client):
                let fullName = "\(client.firstName) \(client.lastName)".trimmingCharacters(in: .whitespaces)
                completion(fullName.isEmpty ? "Noname Noname" : fullName)
            case .failure:
                completion("Noname Noname")
            }
        }
    }
    
    func getUserPhone(completion: @escaping (String) -> Void) {
        guard let clientId = getClientId() else {
            completion("Не указано")
            return
        }
        
        dbManager.fetchDocument(collection: "client", docId: clientId) { (result: Result<ClientFirestore, Error>) in
            switch result {
            case .success(let client):
                completion(client.phone.isEmpty ? "Не указано" : client.phone)
            case .failure:
                completion("Не указано")
            }
        }
    }
    
    func getUserAddress(completion: @escaping (String) -> Void) {
        guard let clientId = getClientId() else {
            completion("Не указано")
            return
        }
        
        dbManager.fetchDocument(collection: "client", docId: clientId) { (result: Result<ClientFirestore, Error>) in
            switch result {
            case .success(let client):
                completion(client.address.isEmpty ? "Не указано" : client.address)
            case .failure:
                completion("Не указано")
            }
        }
    }
}
