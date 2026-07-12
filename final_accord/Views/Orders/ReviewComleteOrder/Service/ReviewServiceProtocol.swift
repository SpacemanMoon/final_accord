import Foundation
//MARK: - ReviewServiceProtocol
protocol ReviewServiceProtocol: AnyObject {
    func submitReview(order: OrderFirestore, rating: Int, comment: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkIfReviewExists(orderId: String, masterId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func fetchReviewsForMaster(masterId: String, completion: @escaping (Result<[String], Error>) -> Void)
    func calculateAverageRating(masterId: String, completion: @escaping (Result<Double, Error>) -> Void)
}
