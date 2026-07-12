import Foundation

//MARK: PromoFirestoreModel
struct PromoFirestoreItem: Codable {
    let id: String
    let imageUrl: String
    let isActive: Bool
    let order: Int
}
