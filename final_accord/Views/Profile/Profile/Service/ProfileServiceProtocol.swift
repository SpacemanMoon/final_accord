import Foundation

// MARK: - ProfileServiceProtocol
protocol ProfileServiceProtocol: AnyObject {
    func fetchProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func updatePushNotifications(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func updateContactInfo(phone: String, city: String?, address: String, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func getCities() -> [String]
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void)
    func reauthenticateAndDelete(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

