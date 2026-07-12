import Foundation

//MARK: OrderFirestoreModel
enum OrderFirestoreStatus: String, Codable {
    case active = "active"
    case completed = "completed"
    case cancelled = "cancelled"
}
