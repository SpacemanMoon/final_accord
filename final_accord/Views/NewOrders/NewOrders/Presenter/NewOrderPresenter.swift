import Foundation

final class NewOrderPresenter {
    
    weak var view: NewOrderViewProtocol?
    private let service: NewOrderServiceProtocol
    private let router: NewOrderRouterProtocol
    private var services: [ServiceFirestoreItem] = []
    private var specialists: [SpecialistFirestore] = []
    private var selectedServiceIndex: Int?
    private var selectedSpecialistIndex: Int?
    private var selectedServiceId: String?
    private var selectedSpecialistId: String?
    
    init(
        view: NewOrderViewProtocol,
        service: NewOrderServiceProtocol,
        router: NewOrderRouterProtocol
    ) {
        self.view = view
        self.service = service
        self.router = router
    }
    
    private func updateButtonState() {
        let isEnabled = selectedServiceId != nil && selectedSpecialistId != nil
        view?.updateButtonState(isEnabled: isEnabled)
    }
}

// MARK: - NewOrderPresenterProtocol
extension NewOrderPresenter: NewOrderPresenterProtocol {
    
    func viewDidLoad() {
        view?.showLoading()
        fetchServices()
    }
    
    func didSelectService(at index: Int) {
        if selectedServiceIndex == index {
            selectedServiceIndex = nil
            selectedServiceId = nil
            selectedSpecialistIndex = nil
            selectedSpecialistId = nil
            specialists = []
            view?.updateServices(with: mapServicesToItems())
            view?.updateSpecialists(with: [])
            updateButtonState()
            return
        }

        selectedSpecialistIndex = nil
        selectedSpecialistId = nil
        specialists = []
        view?.updateSpecialists(with: [])
        
        guard index < services.count else { return }
        selectedServiceIndex = index
        let service = services[index]
        selectedServiceId = service.id
        view?.updateServices(with: mapServicesToItems())
        
        view?.showLoading()
        fetchMasters(for: service.id)
    }
    
    func didSelectSpecialist(at index: Int) {
        if selectedSpecialistIndex == index {
            selectedSpecialistIndex = nil
            selectedSpecialistId = nil
            view?.updateSpecialists(with: mapSpecialistsToItems())
            updateButtonState()
            return
        }
        
        guard index < specialists.count else { return }
        selectedSpecialistIndex = index
        selectedSpecialistId = specialists[index].id
        view?.updateSpecialists(with: mapSpecialistsToItems())
        updateButtonState()
    }
    
    func didTapCreateOrder() {
        guard let serviceId = selectedServiceId,
              let specialistId = selectedSpecialistId else {
            view?.showError("Выберите услугу и специалиста")
            return
        }
        
        guard let service = services.first(where: { $0.id == serviceId }),
              let specialist = specialists.first(where: { $0.id == specialistId }) else {
            view?.showError("Данные не найдены")
            return
        }
        
        router.navigateToConfirmationOrder(service: service, specialist: specialist)
    }
    
    func isServiceSelected(at index: Int) -> Bool {
        return selectedServiceIndex == index
    }
    
    func isSpecialistSelected(at index: Int) -> Bool {
        return selectedSpecialistIndex == index
    }
    
    func getSelectedService() -> ServiceFirestoreItem? {
        guard let index = selectedServiceIndex, index < services.count else {
            return nil
        }
        return services[index]
    }
}

// MARK: - Private Methods
private extension NewOrderPresenter {
    
    func mapServicesToItems() -> [OrderServiceItem] {
        return services.map { service in
            OrderServiceItem(
                imageUrl: service.imageUrl,
                title: service.description
            )
        }
    }
    
    func mapSpecialistsToItems() -> [OrderSpecialistItem] {
        return specialists.map { specialist in
            OrderSpecialistItem(
                avatarUrl: specialist.avatarUrl,
                fullName: specialist.lastName + " " + specialist.firstName,
                rating: specialist.rating,
                profession: specialist.specialization ?? "Не указано",
                reviewText: "\"\(specialist.reviews.first ?? "")\""
            )
        }
    }
    
    func fetchServices() {
        service.fetchServices { [weak self] result in
            self?.handleServicesResult(result)
        }
    }
    
    func fetchMasters(for serviceId: String) {
        service.fetchAvailableMasters(forServiceId: serviceId) { [weak self] result in
            self?.handleMastersResult(result)
        }
    }
    
    func handleServicesResult(_ result: Result<[ServiceFirestoreItem], Error>) {
        let workItem = DispatchWorkItem { [weak self] in
            self?.view?.hideLoading()
            switch result {
            case .success(let services):
                self?.services = services
                self?.view?.updateServices(with: self?.mapServicesToItems() ?? [])
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        DispatchQueue.main.async(execute: workItem)
    }
    
    func handleMastersResult(_ result: Result<[SpecialistFirestore], Error>) {
        let workItem = DispatchWorkItem { [weak self] in
            self?.view?.hideLoading()
            switch result {
            case .success(let specialists):
                self?.specialists = specialists
                self?.view?.updateSpecialists(with: self?.mapSpecialistsToItems() ?? [])
                self?.updateButtonState()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
        DispatchQueue.main.async(execute: workItem)
    }
}
