import Foundation
import FirebaseFirestore

final class ReviewService {
    
    // MARK: - Properties
    
    private let dbManager = FirestoreDatabaseManager.shared
    
    // MARK: - Private Methods
    
    private func generateReviewId() -> String {
        return UUID().uuidString
    }
    
    private func calculateNewRating(currentRating: Double, currentCount: Int, newRating: Double) -> Double {
        let total = currentRating * Double(currentCount) + newRating
        return total / Double(currentCount + 1)
    }
}

// MARK: - ReviewServiceProtocol

extension ReviewService: ReviewServiceProtocol {
    
    func submitReview(order: OrderFirestore, rating: Int, comment: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let specialistPath = "specialists/\(order.masterId)"
        
        dbManager.fetchDocumentByPath(path: specialistPath) { [weak self] result in
            switch result {
            case .success(let data):
                var reviews = data["reviews"] as? [String] ?? []
                reviews.append(comment)
                let currentRating = data["rating"] as? Double ?? 0
                let currentCount = reviews.count - 1
                let newRating = self?.calculateNewRating(
                    currentRating: currentRating,
                    currentCount: currentCount,
                    newRating: Double(rating)
                ) ?? Double(rating)
                
                let isRecommended = newRating >= 4.5
                self?.dbManager.updateDocumentByPath(
                    path: specialistPath,
                    data: [
                        "reviews": reviews,
                        "rating": newRating,
                        "isRecommended": isRecommended
                    ]
                ) { updateResult in
                    switch updateResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkIfReviewExists(orderId: String, masterId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(false))
    }
    
    func fetchReviewsForMaster(masterId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let path = "specialists/\(masterId)"
        
        dbManager.fetchDocumentByPath(path: path) { result in
            switch result {
            case .success(let data):
                let reviews = data["reviews"] as? [String] ?? []
                completion(.success(reviews))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func calculateAverageRating(masterId: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let path = "specialists/\(masterId)"
        
        dbManager.fetchDocumentByPath(path: path) { result in
            switch result {
            case .success(let data):
                let rating = data["rating"] as? Double ?? 0
                completion(.success(rating))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
