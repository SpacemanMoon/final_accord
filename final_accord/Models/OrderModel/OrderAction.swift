import Foundation

//MARK: OrderAction
enum OrderAction {
    case complete
    case cancel
    
    var title: String {
        switch self {
        case .complete:
            return "Завершить заказ"
        case .cancel:
            return "Отменить заказ"
        }
    }
}
