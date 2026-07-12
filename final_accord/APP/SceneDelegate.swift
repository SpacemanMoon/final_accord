import UIKit
import FirebaseAuth
import Firebase

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let rootViewController = getInitialViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Private Methods
    
    private func getInitialViewController() -> UIViewController {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasSeenOnboarding.rawValue)
        
        if !hasSeenOnboarding {
            return OnboardingAssembly.assemble()
        }
        
        let savedUserId = KeychainService.standard.readString(
            service: "ru.developer.MasterCenter.auth",
            account: "userIdentifier"
        )
        
        if let userId = savedUserId {
            return TabBarViewController()
        }
        
        if let currentUser = Auth.auth().currentUser {
            KeychainService.standard.saveString(
                currentUser.uid,
                service: "ru.developer.MasterCenter.auth",
                account: "userIdentifier"
            )
            
            return TabBarViewController()
        }
        
        return RegistrationAssembly.assemble()
    }
}
