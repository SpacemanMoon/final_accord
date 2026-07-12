import Foundation

protocol MainServiceProtocol: AnyObject {
    func fetchPromoCarousel(completion: @escaping (Result<[PromoFirestoreItem], Error>) -> Void)
    func fetchRecommendedMasters(completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void)
    func fetchPopularServices() -> [PopularServicesItem] 
}
