import Foundation

//MARK: - ProfileModel
struct ProfileModel {
    let id: String
    let name: String
    let email: String
    var phone: String
    var city: String?
    var address: String
    var pushNotificationsEnabled: Bool
}
