import Foundation

//MARK: PromoModelCell

struct PromoCellItem {
    let id: String
    let imageUrl: String
    let order: Int
    let isActive: Bool
    
    init(id: String, image: String, order: Int, isActive: Bool) {
        self.id = id
        self.imageUrl = image
        self.order = order
        self.isActive = isActive
    }
}
