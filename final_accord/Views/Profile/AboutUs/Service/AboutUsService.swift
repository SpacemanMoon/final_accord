import Foundation
import FirebaseFirestore

final class AboutUsService {
    
    // MARK: - Properties
    
    private let firestoreManager = FirestoreDatabaseManager.shared
    private let collectionName = "aboutApp"
    private let documentId = " aboutInfo"
}

// MARK: - AboutUsServiceProtocol

extension AboutUsService: AboutUsServiceProtocol {
    
    func fetchAboutData(completion: @escaping (Result<AboutUsModel, Error>) -> Void) {
        firestoreManager.fetchDocument(collection: collectionName,
                                       docId: documentId,
                                       completion: completion)
    }
}
