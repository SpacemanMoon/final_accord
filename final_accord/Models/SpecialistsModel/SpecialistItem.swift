import UIKit

//MARK: SpecialistModelCell
struct SpecialistItem: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let isRecommended: Bool
    let avatarUrl: String?
    let rating: Double
    let reviews: [String]
    let shortInfo: String?
    let education: String?
    let specialization: String?
    
    init(from specialist: SpecialistFirestore) {
        self.id = specialist.id
        self.firstName = specialist.firstName
        self.lastName = specialist.lastName
        self.isRecommended = specialist.isRecommended
        self.avatarUrl = specialist.avatarUrl
        self.rating = specialist.rating
        self.reviews = specialist.reviews
        self.shortInfo = specialist.shortsInfo
        self.education = specialist.education
        self.specialization = specialist.specialization
    }
}
