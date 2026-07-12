import Foundation

//MARK: SpecialistsPresenterProtocol
protocol SpecialistsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchSpecialists()
    func didSelectSpecialist(at index: Int)
}
