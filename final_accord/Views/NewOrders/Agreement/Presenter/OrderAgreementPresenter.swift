import Foundation

final class OrderAgreementPresenter {
    
    // MARK: - Properties
    
    weak var view: OrderAgreementViewProtocol?
    private let agreementService: OrderAgreementServiceProtocol
    private let router: OrderAgreementRouterProtocol
    private let serviceItem: ServiceFirestoreItem
    private let specialist: SpecialistFirestore
    private let profileService: ProfileServiceProtocol
    
    private var currentProfile: ProfileModel?
    private var availableSlots: [String: [String]] = [:]
    private var selectedDate: String?
    private var selectedTime: String?
    
    private var dateItems: [OrderSlotItem] = []
    private var sortedDates: [String] = []
    private var filteredSlots: [String: [String]] = [:]
    private var description: String = ""
    
    // MARK: - Init
    
    init(
        view: OrderAgreementViewProtocol,
        service: OrderAgreementServiceProtocol,
        router: OrderAgreementRouterProtocol,
        serviceItem: ServiceFirestoreItem,
        specialist: SpecialistFirestore,
        profileService: ProfileServiceProtocol
    ) {
        self.view = view
        self.agreementService = service
        self.router = router
        self.serviceItem = serviceItem
        self.specialist = specialist
        self.profileService = profileService
    }
    
    // MARK: - Private Methods
    
    private func loadProfile() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.currentProfile = profile
            case .failure(let error):
                print("⚠️ Failed to load profile: \(error)")
            }
        }
    }
    
    private func updateCurrentTimeSlots() {
        guard let selectedDate = selectedDate else { return }
        
        if let timeSlots = filteredSlots[selectedDate] {
            let items = timeSlots.map { OrderSlotItem(title: $0, isSelected: false) }
            view?.updateTimeSlots(with: items)
        } else {
            view?.updateTimeSlots(with: [])
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        if dateString.contains("-") {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else if dateString.contains(".") {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        } else {
            return dateString
        }
        
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Сегодня"
        }
        
        if calendar.isDateInTomorrow(date) {
            return "Завтра"
        }
        
        let dayNumber = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)
        let weekdayName = getShortWeekdayName(weekday)
        
        return "\(dayNumber) \(weekdayName)"
    }
    
    private func getShortWeekdayName(_ weekday: Int) -> String {
        let weekdays = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
        return weekdays[weekday - 1]
    }
    
    private func updateDateSelection(at index: Int) {
        var updatedItems = dateItems
        for i in 0..<updatedItems.count {
            updatedItems[i].isSelected = (i == index)
        }
        dateItems = updatedItems
        view?.updateDateSlots(with: dateItems)
    }
    
    private func updateTimeSelection(at index: Int) {
        guard let selectedDate = selectedDate,
              let timeSlots = filteredSlots[selectedDate] else { return }
        
        let items = timeSlots.enumerated().map { offset, time in
            OrderSlotItem(title: time, isSelected: offset == index)
        }
        view?.updateTimeSlots(with: items)
    }
    
    private func parseDateTime(date: String, time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if date.contains("-") {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        } else if date.contains(".") {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        } else {
            return nil
        }
        
        let dateTimeString = "\(date) \(time)"
        return dateFormatter.date(from: dateTimeString)
    }
    
    private func fetchAvailableSlots() {
        view?.showLoading()
        
        let group = DispatchGroup()
        var slots: [String: [String]] = [:]
        var existingOrders: [OrderFirestore] = []
        
        group.enter()
        agreementService.fetchAvailableSlots(for: specialist.id) { result in
            switch result {
            case .success(let s):
                slots = s
            case .failure:
                break
            }
            group.leave()
        }
        
        group.enter()
        agreementService.fetchOrders(for: specialist.id) { result in
            switch result {
            case .success(let orders):
                existingOrders = orders.filter { $0.status == .active }
            case .failure:
                break
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            var filteredSlots = slots
            for order in existingOrders {
                if var timeSlots = filteredSlots[order.selectDate] {
                    timeSlots.removeAll { $0 == order.selectTime }
                    if timeSlots.isEmpty {
                        filteredSlots.removeValue(forKey: order.selectDate)
                    } else {
                        filteredSlots[order.selectDate] = timeSlots
                    }
                }
            }
            
            self.availableSlots = slots
            self.filterAvailableSlots(filteredSlots)
            self.updateDateSlots()
            self.view?.hideLoading()
        }
    }
    
    private func filterAvailableSlots(_ slots: [String: [String]]) {
        var filtered: [String: [String]] = [:]
        let calendar = Calendar.current
        let now = Date()
        let twoHoursFromNow = calendar.date(byAdding: .hour, value: 2, to: now) ?? now
        
        for (dateString, timeSlots) in slots {
            let availableTimes = timeSlots.filter { time in
                guard let dateTime = parseDateTime(date: dateString, time: time) else { return false }
                
                if dateTime <= now {
                    return false
                }
                
                if dateTime <= twoHoursFromNow {
                    return false
                }
                
                return true
            }
            
            if !availableTimes.isEmpty {
                filtered[dateString] = availableTimes
            }
        }
        
        filteredSlots = filtered
    }
    
    private func updateDateSlots() {
        sortedDates = filteredSlots.keys.sorted()
        
        if sortedDates.isEmpty {
            view?.updateDateSlots(with: [])
            view?.updateTimeSlots(with: [])
            view?.showNoAvailableSlots()
            return
        }
        
        dateItems = sortedDates.map { dateString in
            let formattedDate = formatDateString(dateString)
            return OrderSlotItem(title: formattedDate, isSelected: false)
        }
        
        view?.updateDateSlots(with: dateItems)
    }
    
    private func createOrder(
        description: String,
        date: String,
        time: String
    ) -> OrderFirestore? {
        
        guard let clientId = agreementService.getClientId() else {
            view?.showError("Ошибка авторизации. Пожалуйста, войдите в аккаунт")
            return nil
        }
        
        guard let profile = currentProfile else {
            view?.showError("Не удалось загрузить данные пользователя")
            return nil
        }
        
        let scheduledDateTime = parseDateTime(date: date, time: time) ?? Date()
        let now = Date()
        
        return OrderFirestore(
            id: UUID().uuidString,
            dateTime: now,
            clientId: clientId,
            masterName: specialist.lastName + " " + specialist.firstName,
            masterId: specialist.id,
            specialization: specialist.specialization,
            issueDescription: description,
            clientName: profile.name,
            clientPhone: profile.phone,
            clientAddress: profile.address,
            status: .active,
            selectTime: time,
            selectDate: date
        )
    }
    
    private func saveOrder(_ order: OrderFirestore) {
        view?.showLoading()
        agreementService.saveOrder(order) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success:
                    self?.scheduleOrderNotifications(order: order)
                    self?.removeBookedSlot(date: order.selectDate, time: order.selectTime)
                    self?.view?.showSuccess()
                    
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func scheduleOrderNotifications(order: OrderFirestore) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if order.selectDate.contains("-") {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        } else if order.selectDate.contains(".") {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        } else {
            return
        }
        
        let dateTimeString = "\(order.selectDate) \(order.selectTime)"
        guard let orderDateTime = dateFormatter.date(from: dateTimeString) else {
            return
        }
        
        guard orderDateTime > Date() else {
            return
        }
        
        let isPushEnabled = currentProfile?.pushNotificationsEnabled ?? true
        LocalNotificationService.shared.scheduleOrderReminders(
            orderId: order.id,
            orderDate: orderDateTime,
        )
    }
    
    private func removeBookedSlot(date: String, time: String) {
        if var timeSlots = filteredSlots[date] {
            timeSlots.removeAll { $0 == time }
            
            if timeSlots.isEmpty {
                filteredSlots.removeValue(forKey: date)
            } else {
                filteredSlots[date] = timeSlots
            }
        }
        if var timeSlots = availableSlots[date] {
            timeSlots.removeAll { $0 == time }
            
            if timeSlots.isEmpty {
                availableSlots.removeValue(forKey: date)
            } else {
                availableSlots[date] = timeSlots
            }
        }
        updateDateSlots()
        updateCurrentTimeSlots()
        if selectedDate == date && filteredSlots[date] == nil {
            selectedDate = nil
            selectedTime = nil
        }
    }
    
    private func returnSlot(date: String, time: String) {
        if var timeSlots = availableSlots[date] {
            if !timeSlots.contains(time) {
                timeSlots.append(time)
                timeSlots.sort()
                availableSlots[date] = timeSlots
            }
        } else {
            availableSlots[date] = [time]
        }
        
        if var timeSlots = filteredSlots[date] {
            if !timeSlots.contains(time) {
                timeSlots.append(time)
                timeSlots.sort()
                filteredSlots[date] = timeSlots
            }
        } else {
            filteredSlots[date] = [time]
        }
        
        updateDateSlots()
        updateCurrentTimeSlots()
    }
    
    private func updateButtonState() {
        let isEnabled = selectedDate != nil && selectedTime != nil && !description.isEmpty
        view?.updateAcceptButton(isEnabled: isEnabled)
    }
}

// MARK: - OrderAgreementPresenterProtocol

extension OrderAgreementPresenter: OrderAgreementPresenterProtocol {
    
    func viewDidLoad() {
        view?.configure(with: serviceItem, specialist: specialist)
        loadProfile()
        fetchAvailableSlots()
    }
    
    func didSelectDate(at index: Int) {
        guard index < sortedDates.count else { return }
        selectedDate = sortedDates[index]
        selectedTime = nil
        
        if let timeSlots = filteredSlots[selectedDate ?? ""] {
            let items = timeSlots.map { OrderSlotItem(title: $0, isSelected: false) }
            view?.updateTimeSlots(with: items)
            updateDateSelection(at: index)
        } else {
            view?.updateTimeSlots(with: [])
        }
        updateButtonState()
    }
    
    func didSelectTime(at index: Int) {
        guard let selectedDate = selectedDate,
              let timeSlots = filteredSlots[selectedDate] else { return }
        guard index < timeSlots.count else { return }
        selectedTime = timeSlots[index]
        
        updateTimeSelection(at: index)
        updateButtonState()
    }
    
    func textViewDidChange(_ text: String) {
        description = text
        updateButtonState()
    }
    
    func didTapAcceptOrder(with description: String) {
        guard let selectedDate = selectedDate,
              let selectedTime = selectedTime else {
            view?.showError("Выберите дату и время")
            return
        }
        guard !description.isEmpty else {
            view?.showError("Опишите проблему")
            return
        }
        
        guard let order = createOrder(
            description: description,
            date: selectedDate,
            time: selectedTime
        ) else {
            return
        }
        
        saveOrder(order)
    }
}
