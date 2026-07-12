import Foundation

//MARK: - ProfileViewProtocol
protocol ProfileViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func updateProfile(with model: ProfileModel)
    func updatePushNotificationState(isOn: Bool)
    func showDeleteAccountConfirmation(completion: @escaping (Bool) -> Void)
    func showSuccessAndNavigate(title: String, message: String)
    func showReauthAlert(completion: @escaping (String?) -> Void)
    func showAvatarPickerOptions()
    func showCameraPicker()
    func showGalleryPicker()
    func updateAvatar(with imageData: Data)
}
