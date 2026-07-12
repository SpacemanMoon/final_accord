import Foundation
import FirebaseAuth

final class AuthorizationService: AuthorizationServiceProtocol {
    
    private let sessionService = UserSessionService.shared
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = authResult?.user.uid else {
                let unknownError = NSError(
                    domain: "Authorization",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Не удалось получить UID пользователя"]
                )
                completion(.failure(unknownError))
                return
            }
            
            self?.sessionService.saveUserID(userId)
            
            completion(.success(userId))
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
