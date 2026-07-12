import Foundation

final class MainService {
    
    // MARK: - Properties
    
    private let dbManager: FirestoreDatabaseManagerProtocol
    
    private let popularServices: [PopularServicesItem] = [
        PopularServicesItem(image: "hammer.fill", description: "Ремонт отделки"),
        PopularServicesItem(image: "poweroutlet.type.b.square.fill", description: "Замена розетки"),
        PopularServicesItem(image: "wrench.fill", description: "Замена счетчика"),
        PopularServicesItem(image: "pencil", description: "Расчет сметы"),
        PopularServicesItem(image: "door.left.hand.closed", description: "Установка двери"),
        PopularServicesItem(image: "blinds.horizontal.open", description: "Установка жалюзи"),
        PopularServicesItem(image: "air.purifier", description: "Установка кондиционера"),
        PopularServicesItem(image: "spigot", description: "Замена смесителя"),
        PopularServicesItem(image: "shower", description: "Ремонт душевой кабины"),
        PopularServicesItem(image: "washer.fill", description: "Ремонт стиральной машины"),
        PopularServicesItem(image: "refrigerator.fill", description: "Ремонт холодильника"),
        PopularServicesItem(image: "wifi", description: "Настройка роутера"),
        PopularServicesItem(image: "macbook", description: "Ремонт ноутбуков"),
        PopularServicesItem(image: "tv", description: "Ремонт телевизора")
    ]
    
    // MARK: - Init
    
    init(dbManager: FirestoreDatabaseManagerProtocol = FirestoreDatabaseManager.shared) {
        self.dbManager = dbManager
    }
}

// MARK: - MainServiceProtocol

extension MainService: MainServiceProtocol {
    
    func fetchPromoCarousel(completion: @escaping (Result<[PromoFirestoreItem], Error>) -> Void) {
        dbManager.fetchFilteredCollectionExact(collection: "promos", field: "isActive", isEqualTo: true) { (result: Result<[PromoFirestoreItem], Error>) in
            switch result {
            case .success(let promos):
                let sortedPromos = promos.sorted { $0.order < $1.order }
                completion(.success(sortedPromos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecommendedMasters(completion: @escaping (Result<[SpecialistFirestore], Error>) -> Void) {
        dbManager.fetchFilteredCollectionExact(collection: "specialists", field: "isRecommended", isEqualTo: true, completion: completion)
    }
    
    func fetchPopularServices() -> [PopularServicesItem] {
        return popularServices
    }
}
