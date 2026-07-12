import Foundation

//MARK: ClientFirestoreModel
struct ClientFirestore: Codable {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var avatarUrl: String?
    var address: String
    var phone: String
    var city: String?
    var pushNotificationsEnabled: Bool
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName
        case lastName
        case avatarUrl
        case address
        case phone
        case city
        case pushNotificationsEnabled
    }
}
