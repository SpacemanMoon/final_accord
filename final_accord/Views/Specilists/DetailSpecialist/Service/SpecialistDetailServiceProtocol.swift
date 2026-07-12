import Foundation

//MARK: SpecialistDetailServiceProtocol
protocol SpecialistDetailServiceProtocol: AnyObject {
    func fetchSpecialistDetails(id: String, completion: @escaping (Result<SpecialistItem, Error>) -> Void)
}
