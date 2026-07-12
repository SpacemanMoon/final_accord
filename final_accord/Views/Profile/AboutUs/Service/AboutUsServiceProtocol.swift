import Foundation

//MARK: - AboutUsServiceProtocol
protocol AboutUsServiceProtocol: AnyObject {
    func fetchAboutData(completion: @escaping (Result<AboutUsModel, Error>) -> Void)
}
