import Foundation

//MARK: - ProfilePresenterProtocol
protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLogout()
    func didTapDeleteAccountSuccess()
    func noticeToggle() -> Bool
    func didChangeNoticeState(isOn: Bool)
    func didChangePhone(_ phone: String)
    func didChangeCity(_ city: String)
    func didChangeAddress(_ address: String)
    func didTapMyOrdersButton()
    func didTapAboutCompanyButton()
    func didTapDeleteAccountButton()
    func getCities() -> [String]
    func didTapAvatar()
    func didSelectCamera()
    func didSelectGallery()
    func didSelectImage(_ imageData: Data)
}
