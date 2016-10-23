import UIKit

final class MainTabBarViewController: UITabBarController {

    fileprivate var customTabBar: MainTabBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [containerTab(), cameraTab(), settingsTab()]
        tabBar.isTranslucent = false
        delegate = self
        customTabBar = tabBar as? MainTabBar
        let offset = UIOffset(horizontal: 0, vertical: -3)
        tabBar.items?.forEach { item in
            item.image = nil
            item.titlePositionAdjustment = offset
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBar?.setupBar()
    }
    
    private func containerTab() -> UINavigationController {
        let controller = ContainerViewController(nibName: "ContainerViewController", bundle: nil)
        let containerNavigationController = NavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: "Photos".uppercased(),
            image: nil,
            selectedImage: nil
        )
        controller.delegate = containerNavigationController
        return containerNavigationController
    }
    
    private func cameraTab() -> UINavigationController {
        let controller = UIViewController()
        let containerNavigationController = UINavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: "Collections".uppercased(),
            image: nil,
            selectedImage: nil
        )
        return containerNavigationController
    }
    
    private func settingsTab() -> UINavigationController {
        let controller = UIViewController()
        let containerNavigationController = UINavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: "You".uppercased(),
            image: nil,
            selectedImage: nil
        )
        return containerNavigationController
    }

}

extension MainTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        customTabBar?.updateBar(toPosition: tabBarController.selectedIndex)
    }
}
