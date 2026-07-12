import Foundation

//MARK: - AboutUsViewProtocol
protocol AboutUsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayAboutData(_ data: AboutUsModel)
    func displayError(_ error: String)
}
