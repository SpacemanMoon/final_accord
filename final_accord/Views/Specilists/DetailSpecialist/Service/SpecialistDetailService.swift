import Foundation

final class SpecialistDetailService {
    
    // MARK: - Properties
    
    private let dbManager: FirestoreDatabaseManagerProtocol
    
    // MARK: - Init
    
    init(dbManager: FirestoreDatabaseManagerProtocol = FirestoreDatabaseManager.shared) {
        self.dbManager = dbManager
    }
}

// MARK: - SpecialistDetailServiceProtocol

extension SpecialistDetailService: SpecialistDetailServiceProtocol {
    
    func fetchSpecialistDetails(id: String, completion: @escaping (Result<SpecialistItem, Error>) -> Void) {
        dbManager.fetchDocument(collection: "specialists", docId: id) { (result: Result<SpecialistFirestore, Error>) in
            switch result {
            case .success(let specialistDetail):
                let detailItem = SpecialistItem(from: specialistDetail)
                completion(.success(detailItem))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
