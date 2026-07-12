import Foundation

//MARK: - RegistrationServiceProtocol
protocol RegistrationServiceProtocol: AnyObject {
    func registerUser(
        name: String,
        lastName: String,
        phone: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func checkIfUserExists(email: String, phone: String, completion: @escaping (Result<Bool, Error>) -> Void)
}
