import Foundation
import FirebaseFirestore

final class FirestoreDatabaseManager {
    
    static let shared = FirestoreDatabaseManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
}

// MARK: - FirestoreDatabaseManagerProtocol

extension FirestoreDatabaseManager: FirestoreDatabaseManagerProtocol {
    
    // MARK: - Document Operations
    
    func saveDocument<T: Encodable>(collection: String, docId: String, item: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection(collection).document(docId).setData(from: item) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchDocument<T: Decodable>(collection: String, docId: String, completion: @escaping (Result<T, Error>) -> Void) {
        db.collection(collection).document(docId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                let customError = NSError(domain: "FirestoreManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Документ не найден"])
                completion(.failure(customError))
                return
            }
            
            do {
                let item = try snapshot.data(as: T.self)
                completion(.success(item))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
    }
    
    func fetchCollection<T: Decodable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let items = documents.compactMap { try? $0.data(as: T.self) }
            completion(.success(items))
        }
    }
    
    func fetchFilteredCollectionExact<T: Decodable>(collection: String, field: String, isEqualTo value: Any, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection).whereField(field, isEqualTo: value).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let items = documents.compactMap { try? $0.data(as: T.self) }
            completion(.success(items))
        }
    }
    
    func fetchFilteredCollection<T: Decodable>(collection: String, field: String, arrayContains value: String, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collection).whereField(field, arrayContains: value).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let items = documents.compactMap { try? $0.data(as: T.self) }
            completion(.success(items))
        }
    }
    
    func updateDocument(collection: String, docId: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(docId).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteDocument(collection: String, docId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collection).document(docId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Path Operations
    
    func setDocumentByPath(path: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.document(path).setData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchCollectionByPath(path: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection(path).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let dataArray = documents.map { $0.data() }
            completion(.success(dataArray))
        }
    }
    
    func fetchDocumentByPath(path: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.document(path).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists, let data = snapshot.data() else {
                let customError = NSError(
                    domain: "FirestoreDatabaseManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Документ не найден"]
                )
                completion(.failure(customError))
                return
            }
            
            completion(.success(data))
        }
    }
    
    func updateDocumentByPath(path: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.document(path).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteDocumentByPath(path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.document(path).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
