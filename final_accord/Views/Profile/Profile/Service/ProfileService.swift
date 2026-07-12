import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ProfileService {
    
    // MARK: - Properties
    
    private let databaseManager = FirestoreDatabaseManager.shared
    private let sessionService = UserSessionService.shared
    private let collectionName = "client"
    
    var cities: [String] {
        return [
            "Москва",
            "Санкт-Петербург",
            "Новосибирск",
            "Екатеринбург",
            "Казань",
            "Нижний Новгород",
            "Челябинск",
            "Самара",
            "Омск",
            "Ростов-на-Дону",
            "Уфа",
            "Красноярск",
            "Пермь",
            "Воронеж",
            "Волгоград",
            "Краснодар",
            "Саратов",
            "Тюмень",
            "Тольятти",
            "Ижевск"
        ]
    }
    
    // MARK: - Private Methods
    
    private func getClientId() -> String? {
        return sessionService.currentUserID
    }
    
    private func mapToProfileModel(from client: ClientFirestore) -> ProfileModel {
        return ProfileModel(
            id: client.id,
            name: client.fullName,
            email: client.email,
            phone: client.phone,
            city: client.city,
            address: client.address,
            pushNotificationsEnabled: client.pushNotificationsEnabled
        )
    }
    
    private func clearUserSession() {
        sessionService.clearUserSession()
    }
}

// MARK: - ProfileServiceProtocol

extension ProfileService: ProfileServiceProtocol {
    
    func fetchProfile(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        guard let clientId = getClientId() else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "ID пользователя не найден"]
            )
            completion(.failure(error))
            return
        }
        
        databaseManager.fetchDocument(
            collection: collectionName,
            docId: clientId
        ) { (result: Result<ClientFirestore, Error>) in
            switch result {
            case .success(let client):
                let profile = self.mapToProfileModel(from: client)
                completion(.success(profile))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updatePushNotifications(enabled: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientId = getClientId() else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "ID пользователя не найден"]
            )
            completion(.failure(error))
            return
        }
        
        let updateData: [String: Any] = [
            "pushNotificationsEnabled": enabled
        ]
        
        databaseManager.updateDocument(
            collection: collectionName,
            docId: clientId,
            data: updateData
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateContactInfo(phone: String, city: String?, address: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientId = getClientId() else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "ID пользователя не найден"]
            )
            completion(.failure(error))
            return
        }
        
        var updateData: [String: Any] = [
            "phone": phone,
            "address": address
        ]
        
        if let city = city {
            updateData["city"] = city
        } else {
            updateData["city"] = NSNull()
        }
        
        databaseManager.updateDocument(
            collection: collectionName,
            docId: clientId,
            data: updateData
        ) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        clearUserSession()
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("⚠️ Firebase signOut error: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(()))
        }
    }
    
    func getCities() -> [String] {
        return cities
    }
    
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
            completion(.failure(error))
            return
        }
        
        guard let clientId = getClientId() else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "ID пользователя не найден"]
            )
            completion(.failure(error))
            return
        }
        
        user.delete { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.databaseManager.deleteDocument(
                collection: self.collectionName,
                docId: clientId
            ) { result in
                switch result {
                case .success:
                    self.clearUserSession()
                    completion(.success(()))
                    
                case .failure(let error):
                    self.clearUserSession()
                    completion(.failure(error))
                }
            }
        }
    }
    
    func reauthenticateAndDelete(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            let error = NSError(
                domain: "ProfileService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]
            )
            completion(.failure(error))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self?.deleteAccount(completion: completion)
        }
    }
}
