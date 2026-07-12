import Foundation
import FirebaseAuth
import Security

final class RegistrationService {
    
    // MARK: - Properties
    
    private let databaseManager = FirestoreDatabaseManager.shared
    private let collectionName = "client"
    
    // MARK: - Private Methods
    
    private func updateUserProfile(authResult: AuthDataResult?, name: String, lastName: String) {
        let fullName = "\(name) \(lastName)"
        let changeRequest = authResult?.user.createProfileChangeRequest()
        changeRequest?.displayName = fullName
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Failed to update displayName: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveUserSession(userId: String) {
        KeychainService.standard.saveString(
            userId,
            service: "ru.developer.MasterCenter.auth",
            account: "userIdentifier"
        )
    }
    
    private func createClientDocument(
        clientId: String,
        email: String,
        name: String,
        lastName: String,
        phone: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let client = ClientFirestore(
            id: clientId,
            email: email,
            firstName: name,
            lastName: lastName,
            avatarUrl: nil,
            address: "",
            phone: phone,
            city: nil,
            pushNotificationsEnabled: true
        )
        
        databaseManager.saveDocument(
            collection: collectionName,
            docId: clientId,
            item: client,
            completion: completion
        )
    }
}

// MARK: - RegistrationServiceProtocol

extension RegistrationService: RegistrationServiceProtocol {
    
    func registerUser(
        name: String,
        lastName: String,
        phone: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = authResult?.user.uid else {
                let unknownError = NSError(
                    domain: "Registration",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Не удалось получить UID пользователя"]
                )
                completion(.failure(unknownError))
                return
            }
            
            self.updateUserProfile(authResult: authResult, name: name, lastName: lastName)
            self.saveUserSession(userId: userId)
            self.createClientDocument(
                clientId: userId,
                email: email,
                name: name,
                lastName: lastName,
                phone: phone,
                completion: completion
            )
        }
    }
    
    func checkIfUserExists(email: String, phone: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let group = DispatchGroup()
        var emailExists = false
        var phoneExists = false
        var fetchError: Error?
        
        group.enter()
        databaseManager.fetchFilteredCollectionExact(
            collection: collectionName,
            field: "email",
            isEqualTo: email
        ) { (result: Result<[ClientFirestore], Error>) in
            switch result {
            case .success(let clients):
                emailExists = !clients.isEmpty
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.enter()
        databaseManager.fetchFilteredCollectionExact(
            collection: collectionName,
            field: "phone",
            isEqualTo: phone
        ) { (result: Result<[ClientFirestore], Error>) in
            switch result {
            case .success(let clients):
                phoneExists = !clients.isEmpty
            case .failure(let error):
                fetchError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                completion(.failure(error))
            } else {
                completion(.success(emailExists || phoneExists))
            }
        }
    }
}
