import Foundation
import FirebaseAuth

final class ProfilePresenter {
    
    // MARK: - Properties
    
    weak var view: ProfileViewProtocol?
    private let service: ProfileServiceProtocol
    private let router: ProfileRouterProtocol
    
    private var currentProfile: ProfileModel?
    
    // MARK: - Init
    
    init(view: ProfileViewProtocol, service: ProfileServiceProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.service = service
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func loadProfile() {
        view?.showLoading()
        
        service.fetchProfile { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let profile):
                self.currentProfile = profile
                self.view?.updateProfile(with: profile)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
    
    private func deleteAccount() {
        view?.showLoading()
        
        service.deleteAccount { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success:
                self.view?.showSuccessAndNavigate(
                    title: "Аккаунт удален",
                    message: "Ваш аккаунт был успешно удален."
                )
                
            case .failure(let error):
                let nsError = error as NSError
                if let errorCode = AuthErrorCode(rawValue: nsError.code),
                   errorCode == .requiresRecentLogin {
                    self.view?.showReauthAlert { [weak self] password in
                        guard let self = self else { return }
                        guard let password = password, !password.isEmpty else {
                            self.view?.showError("Пароль не может быть пустым")
                            return
                        }
                        self.reauthAndDelete(password: password)
                    }
                } else {
                    self.view?.showError("Не удалось удалить аккаунт: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func reauthAndDelete(password: String) {
        guard let email = currentProfile?.email else {
            view?.showError("Email не найден. Пожалуйста, выйдите и войдите заново.")
            return
        }
        
        view?.showLoading()
        
        service.reauthenticateAndDelete(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success:
                self.view?.showSuccessAndNavigate(
                    title: "Аккаунт удален",
                    message: "Ваш аккаунт был успешно удален."
                )
                
            case .failure(let error):
                let nsError = error as NSError
                if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                    switch errorCode {
                    case .wrongPassword:
                        self.view?.showError("Неверный пароль. Попробуйте снова.")
                    case .userNotFound:
                        self.view?.showError("Пользователь не найден.")
                    default:
                        self.view?.showError("Ошибка: \(error.localizedDescription)")
                    }
                } else {
                    self.view?.showError("Ошибка: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    
    func viewDidLoad() {
        PermissionManager.shared.requestAllPermissions()
        loadProfile()
    }

    func didTapLogout() {
        service.logout { [weak self] result in
            switch result {
            case .success:
                self?.router.navigateToLogin()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didTapDeleteAccountSuccess() {
        router.navigateToLogin()
    }
    
    func noticeToggle() -> Bool {
        return currentProfile?.pushNotificationsEnabled ?? true
    }
    
    func didChangeNoticeState(isOn: Bool) {
        currentProfile?.pushNotificationsEnabled = isOn
        
        service.updatePushNotifications(enabled: isOn) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.view?.showError("Не удалось обновить настройки: \(error.localizedDescription)")
                self?.view?.updatePushNotificationState(isOn: !isOn)
            }
        }
    }
    
    func didChangePhone(_ phone: String) {
        guard let currentProfile = currentProfile else { return }
        
        self.currentProfile?.phone = phone
        
        service.updateContactInfo(
            phone: phone,
            city: currentProfile.city,
            address: currentProfile.address
        ) { [weak self] result in
            switch result {
            case .success:
                if let profile = self?.currentProfile {
                    self?.view?.updateProfile(with: profile)
                }
            case .failure(let error):
                self?.view?.showError("Не удалось сохранить телефон: \(error.localizedDescription)")
            }
        }
    }
    
    func didChangeCity(_ city: String) {
        guard let currentProfile = currentProfile else { return }
        
        self.currentProfile?.city = city
        
        service.updateContactInfo(
            phone: currentProfile.phone,
            city: city,
            address: currentProfile.address
        ) { [weak self] result in
            switch result {
            case .success:
                if let profile = self?.currentProfile {
                    self?.view?.updateProfile(with: profile)
                }
            case .failure(let error):
                self?.view?.showError("Не удалось сохранить город: \(error.localizedDescription)")
            }
        }
    }
    
    func didChangeAddress(_ address: String) {
        guard let currentProfile = currentProfile else { return }
        
        self.currentProfile?.address = address
        
        service.updateContactInfo(
            phone: currentProfile.phone,
            city: currentProfile.city,
            address: address
        ) { [weak self] result in
            switch result {
            case .success:
                if let profile = self?.currentProfile {
                    self?.view?.updateProfile(with: profile)
                }
            case .failure(let error):
                self?.view?.showError("Не удалось сохранить адрес: \(error.localizedDescription)")
            }
        }
    }
    
    func didTapMyOrdersButton() {
        router.navigateToAllOrders()
    }
    
    func didTapAboutCompanyButton() {
        router.navigateToAboutCompany()
    }
    
    func didTapDeleteAccountButton() {
        view?.showDeleteAccountConfirmation { [weak self] confirmed in
            guard let self = self else { return }
            if confirmed {
                self.deleteAccount()
            }
        }
    }
    
    func getCities() -> [String] {
        return service.getCities()
    }
    
    func didTapAvatar() {
        view?.showAvatarPickerOptions()
    }
    
    func didSelectCamera() {
        view?.showCameraPicker()
    }
    
    func didSelectGallery() {
        view?.showGalleryPicker()
    }
    
    func didSelectImage(_ imageData: Data) {
        view?.updateAvatar(with: imageData)
    }
}
