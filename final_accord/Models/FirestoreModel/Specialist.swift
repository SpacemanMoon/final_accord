import Foundation

//MARK: SpecialistFirestoreModel
struct SpecialistFirestore: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let isRecommended: Bool
    let avatarUrl: String?
    let rating: Double
    let reviews: [String]
    let shortsInfo: String?
    let education: String?
    let specialization: String?
    let servicesIds: [String]
    let workingHours: [Int]
    let workingDays: [Int]
}
