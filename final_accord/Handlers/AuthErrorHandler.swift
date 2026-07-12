import Foundation
import FirebaseAuth

//MARK: - AuthErrorHandler
enum AuthErrorHandler {
    static func description(for error: Error) -> String {

        var friendlyMessage = "Произошла непредвиденная ошибка. Попробуйте позже."
        
        if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
            
            switch errorCode {
            case .userNotFound:
                friendlyMessage = "Пользователя с такой почтой не существует. Проверьте ввод или зарегистрируйтесь."
                
            case .wrongPassword:
                friendlyMessage = "Неверный пароль. Пожалуйста, попробуйте еще раз."
                
            case .invalidEmail:
                friendlyMessage = "Некорректный формат адреса электронной почты."
                
            case .networkError:
                friendlyMessage = "Проблема с интернетом. Проверьте подключение к сети."
                
            case .invalidCredential:
                friendlyMessage = "Неверно указана почта или пароль. Пожалуйста, проверьте данные."
                
            case .emailAlreadyInUse:
                friendlyMessage = "Пользователь с таким Email уже зарегистрирован в системе."
                
            case .weakPassword:
                friendlyMessage = "Слишком простой пароль. Пароль должен содержать не менее 6 символов."
                
            default:
                friendlyMessage = error.localizedDescription
            }
        }
        
        return friendlyMessage
    }
}
