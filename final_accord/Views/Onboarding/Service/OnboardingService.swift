import Foundation

final class OnboardingService{}

// MARK: - OnboardingServiceProtocol

extension OnboardingService: OnboardingServiceProtocol{
    
    func fetchOnboardingItems() -> [OnboardingItem] {
        return [
            OnboardingItem(image: "onboarding1"),
            OnboardingItem(image: "onboarding2"),
            OnboardingItem(image: "onboarding3")
        ]
    }
    
    func hasSeenOnboarding() -> Bool {
        let key = UserDefaultsKeys.hasSeenOnboarding.rawValue
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setOnboardingSeen() {
        let key = UserDefaultsKeys.hasSeenOnboarding.rawValue
        UserDefaults.standard.set(true, forKey: key)
    }
}
