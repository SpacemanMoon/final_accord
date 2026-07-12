import Foundation

final class RegistrationValidator {
    
    func validateName(_ name: String?) -> String? {
        guard let name = name, !name.isEmpty else {
            return "Введите имя"
        }
        return nil
    }
    
    func validateLastName(_ lastName: String?) -> String? {
        guard let lastName = lastName, !lastName.isEmpty else {
            return "Введите фамилию"
        }
        return nil
    }
    
    func validateEmail(_ email: String?) -> String? {
        guard let email = email, !email.isEmpty else {
            return "Введите email"
        }
        
        guard isValidEmail(email) else {
            return "Некорректный формат email"
        }
        
        guard isValidEmailDomain(email) else {
            return "Неверный домен"
        }
        
        return nil
    }
    
    func validatePhone(_ phone: String?) -> String? {
        guard let phone = phone, !phone.isEmpty else {
            return "Введите номер телефона"
        }
        
        guard isValidPhone(phone) else {
            return "Некорректный формат телефона"
        }
        
        return nil
    }
    
    func validatePassword(_ password: String?) -> String? {
        guard let password = password, !password.isEmpty else {
            return "Введите пароль"
        }
        
        guard password.count >= 6 else {
            return "Пароль должен содержать минимум 6 символов"
        }
        
        return nil
    }
    
    func validateConfirmPassword(_ password: String?, confirm: String?) -> String? {
        guard let confirmPassword = confirm, !confirmPassword.isEmpty else {
            return "Подтвердите пароль"
        }
        
        guard let password = password, password == confirmPassword else {
            return "Пароли не совпадают"
        }
        
        return nil
    }
    
    // MARK: - Private Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidEmailDomain(_ email: String) -> Bool {
        let allowedDomains = ["gmail.com", "yandex.ru", "mail.ru", "icloud.com"]
        
        guard let domain = email.components(separatedBy: "@").last?.lowercased() else {
            return false
        }
        
        return allowedDomains.contains(domain)
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^\\+?[0-9]{10,11}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
}
