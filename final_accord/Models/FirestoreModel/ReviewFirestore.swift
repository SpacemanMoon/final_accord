import Foundation

struct ReviewFirestore: Codable {
    let id: String
    let orderId: String
    let masterId: String
    let clientId: String
    let rating: Int
    let comment: String?
    let createdAt: Date
}
