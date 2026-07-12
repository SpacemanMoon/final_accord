import Foundation

final class SpecialistsService {
    
    // MARK: - Properties
    
    private let dbManager: FirestoreDatabaseManagerProtocol
    
    // MARK: - Init
    
    init(dbManager: FirestoreDatabaseManagerProtocol = FirestoreDatabaseManager.shared) {
        self.dbManager = dbManager
    }
}

// MARK: - SpecialistsServiceProtocol

extension SpecialistsService: SpecialistsServiceProtocol {
    
    func fetchMasters(completion: @escaping (Result<[SpecialistItem], Error>) -> Void) {
        dbManager.fetchCollection(collection: "specialists") { (result: Result<[SpecialistFirestore], Error>) in
            switch result {
            case .success(let firestoreItems):
                let specialistItems = firestoreItems.map { SpecialistItem(from: $0) }
                completion(.success(specialistItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
