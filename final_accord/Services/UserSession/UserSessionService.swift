import Foundation

final class UserSessionService {
    
    static let shared = UserSessionService()
    
    private let keychain = KeychainService.standard
    private let serviceName = "ru.developer.MasterCenter.auth"
    private let accountName = "userIdentifier"
    
    private init() {}
    
    // MARK: - Session Management
    
    var currentUserID: String? {
        return keychain.readString(service: serviceName, account: accountName)
    }
    
    var isUserLoggedIn: Bool {
        return currentUserID != nil
    }
    
    @discardableResult
    func saveUserID(_ userID: String) -> Bool {
        return keychain.saveString(userID, service: serviceName, account: accountName)
    }
    
    @discardableResult
    func clearUserSession() -> Bool {
        return keychain.delete(service: serviceName, account: accountName)
    }
    
    // MARK: - User Info (из Firestore)
    
    func fetchCurrentUserInfo(completion: @escaping (Result<ClientFirestore, Error>) -> Void) {
        guard let userID = currentUserID else {
            let error = NSError(
                domain: "UserSessionService",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
            completion(.failure(error))
            return
        }
        
        FirestoreDatabaseManager.shared.fetchDocument(
            collection: "client",
            docId: userID,
            completion: completion
        )
    }
}
