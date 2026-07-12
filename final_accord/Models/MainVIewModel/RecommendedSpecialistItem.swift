import UIKit

//MARK: RecommendedSpecialistModelCell
struct RecommendedSpecialistItem {
    let id: String
    let fullName: String
    let specialization: String
    let rating: Double
    let reviewsCount: String
    let isOnline: Bool
    let avatarUrl: String? 
}
//MARK: - extension RecommendedSpecialistItem
extension RecommendedSpecialistItem {
    init(from firestore: SpecialistFirestore) {
        self.id = firestore.id
        self.fullName = "\(firestore.firstName) \(firestore.lastName)"
        self.specialization = firestore.specialization ?? "Мастер"
        self.rating = firestore.rating
        self.reviewsCount = "\(firestore.reviews.count) отзывов"
        self.isOnline = true
        self.avatarUrl = firestore.avatarUrl
    }
}
