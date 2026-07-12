import Foundation

//MARK: OrderFirestoreModel
struct OrderFirestore: Codable {
    let id: String
    let dateTime: Date
    let clientId: String
    let masterName: String
    let masterId: String
    let specialization: String?
    let issueDescription: String
    let clientName: String
    let clientPhone: String
    let clientAddress: String
    var status: OrderFirestoreStatus
    let selectTime: String
    let selectDate: String
}
