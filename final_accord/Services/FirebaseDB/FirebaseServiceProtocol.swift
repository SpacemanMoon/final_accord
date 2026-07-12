import Foundation

//MARK: - FirestoreDatabaseManagerProtocol
protocol FirestoreDatabaseManagerProtocol {

    func saveDocument<T: Encodable>(collection: String, docId: String, item: T, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchDocument<T: Decodable>(collection: String, docId: String, completion: @escaping (Result<T, Error>) -> Void)
    func fetchCollection<T: Decodable>(collection: String, completion: @escaping (Result<[T], Error>) -> Void)
    func fetchFilteredCollectionExact<T: Decodable>(collection: String, field: String, isEqualTo value: Any, completion: @escaping (Result<[T], Error>) -> Void)
    func fetchFilteredCollection<T: Decodable>(collection: String, field: String, arrayContains value: String, completion: @escaping (Result<[T], Error>) -> Void)
    func updateDocument(collection: String, docId: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func deleteDocument(collection: String, docId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func setDocumentByPath(path: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchCollectionByPath(path: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void)
    func fetchDocumentByPath(path: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    func updateDocumentByPath(path: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func deleteDocumentByPath(path: String, completion: @escaping (Result<Void, Error>) -> Void)
}
