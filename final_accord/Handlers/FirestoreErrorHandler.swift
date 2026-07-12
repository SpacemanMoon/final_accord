import Foundation
import FirebaseFirestore

// MARK: - FirestoreErrorHandler
enum FirestoreErrorHandler {
    static func description(for error: Error) -> String {
        var friendlyMessage = "Не удалось загрузить данные. Попробуйте позже."
        
        let nsError = error as NSError
        if nsError.domain == FirestoreErrorDomain {
            if let errorCode = FirestoreErrorCode.Code(rawValue: nsError.code) {
                switch errorCode {
                case .cancelled:
                    friendlyMessage = "Операция была отменена."
                case .unknown:
                    friendlyMessage = "Произошла неизвестная ошибка базы данных."
                case .deadlineExceeded:
                    friendlyMessage = "Время ожидания ответа от сервера истекло. Проверьте интернет."
                case .notFound:
                    friendlyMessage = "Запрашиваемые данные не найдены на сервере."
                case .alreadyExists:
                    friendlyMessage = "Такой документ уже существует."
                case .permissionDenied:
                    friendlyMessage = "У вас нет прав для доступа к этим данным."
                case .unavailable:
                    friendlyMessage = "Сервер временно недоступен. Проверьте подключение к сети."
                default:
                    friendlyMessage = error.localizedDescription
                }
            }
        }
        
        return friendlyMessage
    }
}
