import Foundation

final class NewOrderService {
    
    private let dbManager: FirestoreDatabaseManagerProtocol
    
    init(dbManager: FirestoreDatabaseManagerProtocol = FirestoreDatabaseManager.shared) {
        self.dbManager = dbManager
    }
}

// MARK: - NewOrderServiceProtocol
extension NewOrderService: NewOrderServiceProtocol {
    
    func saveOrder(_ order: OrderFirestore, completion: @escaping (Result<Void, Error>) -> Void) {
        dbManager.saveDocument(
            collection: "orders",
            docId: order.id,
            item: order,
            completion: completion
        )
    }
    
    func fetchAllMasters(completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void) {
        dbManager.fetchCollection(
            collection: "specialists",
            completion: completion
        )
    }
    
    func fetchAvailableMasters(forServiceId serviceId: String, completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void) {
        dbManager.fetchFilteredCollection(
            collection: "specialists",
            field: "servicesIds",
            arrayContains: serviceId,
            completion: completion
        )
    }
    
    func fetchServices(completion: @escaping (Result<[ServiceFirestoreItem], Error>) -> Void) {
        dbManager.fetchCollection(
            collection: "services",
            completion: completion
        )
    }
}
