import Foundation

//MARK: - AuthorizationServiceProtocol
protocol AuthorizationServiceProtocol {
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}
