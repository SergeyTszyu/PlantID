//
//  MainCoordinator.swift

import UIKit

fileprivate enum TabItem: Int {
    case myGarden
    case mushroom
    case chat
    case profile
}

class MainCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        let tabBar = getTabBarContoller()
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([tabBar], animated: false)
    }
    
    private func getTabBarContoller() -> UITabBarController {
        let gardenViewController = NewMyGardenViewController()
        let gardenNavigationController = UINavigationController(rootViewController: gardenViewController)
        
        let historyViewController = ChatViewController()
        let historyNavigationConntroller = UINavigationController(rootViewController: historyViewController)
        
        gardenNavigationController.tabBarItem = UITabBarItem(title: "My Garden",
                                                  image: UIImage(named: "TabBar-MyGarden"),
                                                  selectedImage: UIImage(named: "TabBar-MyGarden"))
        gardenNavigationController.tabBarItem.tag = TabItem.myGarden.rawValue
        
        let musroomVC = MushroomIDViewController()
        let gardemusroomVCNavigationController = UINavigationController(rootViewController: musroomVC)
        gardemusroomVCNavigationController.tabBarItem = UITabBarItem(title: "MushroomID",
                                                  image: UIImage(named: "TabBar-Mushroom"),
                                                  selectedImage: UIImage(named: "TabBar-Mushroom"))
        gardemusroomVCNavigationController.tabBarItem.tag = TabItem.mushroom.rawValue
        
        historyNavigationConntroller.tabBarItem = UITabBarItem(title: "AI Chat",
                                                            image: UIImage(named: "TabBar-Chat"),
                                                            selectedImage: UIImage(named: "TabBar-Chat"))
        historyNavigationConntroller.tabBarItem.tag = TabItem.chat.rawValue
        
        let profileViewController = SettingsViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                            image: UIImage(named: "TabBar-Profile"),
                                                            selectedImage: UIImage(named: "TabBar-Profile"))
        let profileNavigationConntroller = UINavigationController(rootViewController: profileViewController)
        profileNavigationConntroller.tabBarItem.tag = TabItem.profile.rawValue
        
        let tabBarController = CustomTabBarController()
        
        tabBarController.viewControllers = [gardenNavigationController,
                                            gardemusroomVCNavigationController,
                                            historyNavigationConntroller,
                                            profileNavigationConntroller]
        
        tabBarController.tabBar.unselectedItemTintColor = UIColor.dynamicColor(
            light: UIColor(hexString: "#1D3C2B")!,
            dark: UIColor(hexString: "#1D3C2B")!
        )
        
        tabBarController.tabBar.tintColor = UIColor.dynamicColor(
            light: UIColor(hexString: "#0A9E03")!,
            dark: UIColor(hexString: "#0A9E03")!
        )
        
        tabBarController.mainCoordinator = self
        
        return tabBarController
    }
    
    func showRulerScreen() {
        let rulerViewController = UIViewController()
        navigationController.pushViewController(rulerViewController, animated: true)
    }
    
    func showBubbleLevelScreen() {
        let bubbleLevelViewController = UIViewController()
        navigationController.pushViewController(bubbleLevelViewController, animated: true)
    }
}

// MARK: - OnboardingRoutingDelegate

extension MainCoordinator: MainRouterDelegate {
    func routeToSettings() {
        SettingsCoordinator(navigationController: navigationController).start()
    }

    func routeToCamera() {
    }
    
    func routeToTrial() {
        PaywallCoordinator(navigationController: navigationController).start()
    }
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    var mainCoordinator: MainCoordinator?
    private var previousIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let mainCoordinator = mainCoordinator,
        let tabItem = TabItem(rawValue: item.tag) else { return }
        switch tabItem {
        default:
            previousIndex = selectedIndex
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewControllers?.firstIndex(of: viewController) {
            previousIndex = selectedIndex
        }
        if let navController = viewController as? UINavigationController {
              if navController.viewControllers.count > 1 { navController.popToRootViewController(animated: false) }
        }
        return true
     }
}

protocol MainRouterDelegate: AnyObject {
    func routeToSettings()
    func routeToCamera()
    func routeToTrial()
}
