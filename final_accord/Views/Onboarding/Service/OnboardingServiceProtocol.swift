import Foundation

protocol OnboardingServiceProtocol: AnyObject {
    func fetchOnboardingItems() -> [OnboardingItem]
    func hasSeenOnboarding() -> Bool
    func setOnboardingSeen()
}
