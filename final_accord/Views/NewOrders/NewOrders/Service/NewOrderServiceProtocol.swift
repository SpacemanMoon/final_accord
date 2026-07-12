import Foundation

protocol NewOrderServiceProtocol {
    func saveOrder(_ order: OrderFirestore, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchAllMasters(completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void)
    func fetchAvailableMasters(forServiceId serviceId: String, completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void)
    func fetchServices(completion: @escaping (Result<[ServiceFirestoreItem], Error>) -> Void)
}
