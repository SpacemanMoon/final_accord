import Foundation

//MARK: - ReviewModel
struct Review: Codable {
    let id: String?
    let orderId: String
    let clientId: String
    let rating: Int 
    let comment: String
    let date: Date
    
    init(id: String? = nil,
         orderId: String,
         clientId: String,
         rating: Int,
         comment: String,
         date: Date) {
        self.id = id
        self.orderId = orderId
        self.clientId = clientId
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}
