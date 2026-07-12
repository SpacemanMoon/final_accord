import UIKit
import UserNotifications

final class LocalNotificationService {
    
    // MARK: - Singleton
    
    static let shared = LocalNotificationService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let sessionService = UserSessionService.shared
    private let databaseManager = FirestoreDatabaseManager.shared
    
    private init() {}
    
    // MARK: - Public Methods
    
    func scheduleOrderReminders(orderId: String, orderDate: Date) {
        checkPushNotificationsEnabled { [weak self] isEnabled in
            guard let self = self, isEnabled else { return }
            
            self.cancelOrderNotifications(orderId: orderId)
            
            self.scheduleNotification(
                orderId: orderId,
                triggerDate: orderDate.addingTimeInterval(-24 * 60 * 60),
                title: "Напоминаю",
                body: "До выполнения заказа остались сутки"
            )
            
            self.scheduleNotification(
                orderId: orderId,
                triggerDate: orderDate.addingTimeInterval(-2 * 60 * 60),
                title: "Напоминаю!",
                body: "До выполнения заказа осталось всего 2 часа"
            )
            
            self.scheduleNotification(
                orderId: orderId,
                triggerDate: orderDate.addingTimeInterval(-60 * 60),
                title: "Напоминаю",
                body: "До выполнения заказа остался 1 час"
            )
        }
    }
    
    func cancelOrderNotifications(orderId: String) {
        notificationCenter.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { $0.identifier.hasPrefix("\(orderId)_") }
                .map { $0.identifier }
            
            if !identifiersToRemove.isEmpty {
                self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            }
        }
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    // MARK: - Private Methods
    
    private func checkPushNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        guard let userId = sessionService.currentUserID else {
            completion(false)
            return
        }
        
        databaseManager.fetchDocument(
            collection: "client",
            docId: userId
        ) { (result: Result<ClientFirestore, Error>) in
            switch result {
            case .success(let client):
                completion(client.pushNotificationsEnabled)
            case .failure:
                completion(true)
            }
        }
    }
    
    private func scheduleNotification(orderId: String, triggerDate: Date, title: String, body: String) {
        guard triggerDate > Date() else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )
        
        let identifier = "\(orderId)_\(triggerDate.timeIntervalSince1970)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { _ in }
    }
}
