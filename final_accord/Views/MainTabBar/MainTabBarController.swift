import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = .zero
        setupUI()
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .cyan
        tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1.0)
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        
        let fixedColor = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = fixedColor

            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {

            tabBar.barTintColor = fixedColor
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
        }
    }
    
    private func setupViewControllers() {
        let mainVC = MainAssembly.assemble()
        let specialistsVC = SpecialistsAssembly.assemble()
        let newOrderVC = NewOrderAssembly.assemble()
        let ordersVC = OrdersAssembly.assemble()
        let profileVC = ProfileAssembly.assemble()
        
        let mainNav = createNavigationController(with: mainVC)
        let specialistsNav = createNavigationController(with: specialistsVC)
        let newOrderNav = createNavigationController(with: newOrderVC)
        let ordersNav = createNavigationController(with: ordersVC)
        let profileNav = createNavigationController(with: profileVC)
        
        mainNav.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
        specialistsNav.tabBarItem = UITabBarItem(title: "Мастера", image: UIImage(systemName: "wrench.and.screwdriver.fill"), tag: 1)
        newOrderNav.tabBarItem = UITabBarItem(title: "Заказ", image: UIImage(systemName: "plus.circle.fill"), tag: 2)
        ordersNav.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "doc.text.fill"), tag: 3)
        profileNav.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), tag: 4)
        
        viewControllers = [mainNav, specialistsNav, newOrderNav, ordersNav, profileNav]
    }
    
    private func createNavigationController(with rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        nav.additionalSafeAreaInsets = .zero
        return nav
    }
}
