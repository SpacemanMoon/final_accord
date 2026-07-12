import Foundation

//MARK: MainPresenterProtoco;
protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidPullToRefresh()
    func didSelectItemPopularService()
    func didSelectRecommendedMasters(with id: String) 
}
