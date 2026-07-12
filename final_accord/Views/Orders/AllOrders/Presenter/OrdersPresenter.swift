import Foundation

final class OrdersPresenter {
    
    // MARK: - Properties
    
    weak var view: OrdersViewProtocol?
    private let service: OrdersServiceProtocol
    private let router: OrdersRouterProtocol
    
    private var activeOrders: [OrderFirestore] = []
    private var completedOrders: [OrderFirestore] = []
    private var isLoading = false
    
    // MARK: - Init
    
    init(view: OrdersViewProtocol, service: OrdersServiceProtocol, router: OrdersRouterProtocol) {
        self.view = view
        self.service = service
        self.router = router
    }
    
    // MARK: - Private Methods
    
    private func loadOrders(showLoading: Bool = true) {
        guard !isLoading else { return }
        isLoading = true
        
        if showLoading {
            view?.showLoading(true)
        }
        
        service.fetchMyOrders { [weak self] result in
            guard let self = self else { return }
            
            self.view?.showLoading(false)
            self.view?.endRefreshing()
            self.isLoading = false
            
            switch result {
            case .success(let orders):
                self.processOrders(orders)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
    
    private func processOrders(_ orders: [OrderFirestore]) {
        let active = orders.filter { $0.status == .active }
        let completed = orders.filter { $0.status == .completed }
        let cancelled = orders.filter { $0.status == .cancelled }
        
        self.activeOrders = active.sorted { $0.dateTime > $1.dateTime }
        self.completedOrders = (completed + cancelled).sorted { $0.dateTime > $1.dateTime }
        
        view?.showOrders(activeOrders: activeOrders, completedOrders: completedOrders)
    }
    
    private func updateOrderStatus(order: OrderFirestore,
                                   newStatus: OrderFirestoreStatus, at index: Int, in section: OrdersSection) {
        view?.showLoading(true)
        
        service.updateOrderStatus(orderId: order.id, status: newStatus) { [weak self] result in
            guard let self = self else { return }
            self.view?.showLoading(false)
            
            switch result {
            case .success:
                if newStatus == .cancelled {
                    self.returnSlot(for: order)
                }
                
                self.moveOrder(order: order, to: newStatus)
                self.view?.showOrders(activeOrders: self.activeOrders, completedOrders: self.completedOrders)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
    
    private func moveOrder(order: OrderFirestore, to newStatus: OrderFirestoreStatus) {
        activeOrders.removeAll { $0.id == order.id }
        completedOrders.removeAll { $0.id == order.id }
        
        var updatedOrder = order
        updatedOrder.status = newStatus
        
        if newStatus == .active {
            activeOrders.insert(updatedOrder, at: 0)
        } else {
            completedOrders.insert(updatedOrder, at: 0)
        }
    }
    
    private func determineOrderAction(_ order: OrderFirestore) -> OrderAction? {
        guard order.status == .active else { return nil }
        
        let calendar = Calendar.current
        let scheduledDate = dateFromString(order.selectDate, order.selectTime) ?? order.dateTime
        let now = Date()
        let hoursDifference = calendar.dateComponents([.hour], from: now, to: scheduledDate).hour ?? 0
        
        if hoursDifference > 2 {
            return .cancel
        }
        if hoursDifference < 0 {
            return .complete
        }
        return nil
    }
    
    private func dateFromString(_ date: String, _ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.date(from: "\(date) \(time)")
    }
    
    private func returnSlot(for order: OrderFirestore) {
        service.returnSlot(
            date: order.selectDate,
            time: order.selectTime,
            masterId: order.masterId
        ) { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
}

// MARK: - OrdersPresenterProtocol

extension OrdersPresenter: OrdersPresenterProtocol {
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        loadOrders(showLoading: true)
    }
    
    func viewWillAppear() {
        loadOrders(showLoading: false)
    }
    
    func refreshOrders() {
        loadOrders(showLoading: false)
    }
    
    // MARK: - Data Methods for View
    
    func getOrders(for segment: Int) -> [OrderFirestore] {
        return segment == 0 ? activeOrders : completedOrders
    }
    
    func getOrderAction(_ order: OrderFirestore) -> OrderAction? {
        return determineOrderAction(order)
    }
    
    func shouldShowReviewButton(for order: OrderFirestore) -> Bool {
        return order.status == .completed
    }
    
    // MARK: - Actions
    
    func didTapActionButton(on order: OrderFirestore, at index: Int, in section: OrdersSection) {
        guard let action = determineOrderAction(order) else { return }
        
        let newStatus: OrderFirestoreStatus
        let actionDescription: String
        
        switch action {
        case .complete:
            newStatus = .completed
            actionDescription = "завершить"
        case .cancel:
            newStatus = .cancelled
            actionDescription = "отменить"
        }
        
        view?.showConfirmationAlert(
            title: "Подтверждение",
            message: "Вы уверены, что хотите \(actionDescription) заказ?",
            confirmAction: { [weak self] in
                self?.updateOrderStatus(order: order, newStatus: newStatus, at: index, in: section)
            }
        )
    }
    
    func didTapReviewButton(on order: OrderFirestore) {
        view?.showLoading(true)
        service.checkIfReviewExists(orderId: order.id) { [weak self] result in
            guard let self = self else { return }
            self.view?.showLoading(false)
            
            switch result {
            case .success(let exists):
                if exists {
                    self.view?.showError("Вы уже оставили отзыв для этого заказа")
                } else {
                    self.router.navigateToReview(order: order)
                }
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
