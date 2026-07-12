import Foundation

protocol SpecialistsServiceProtocol: AnyObject {
    func fetchMasters(completion: @escaping (Result<[SpecialistItem], Error>) -> Void)
}
