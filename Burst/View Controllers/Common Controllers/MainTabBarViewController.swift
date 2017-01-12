import UIKit
import BurstAPI

final class MainTabBarViewController: UITabBarController {

    fileprivate var customTabBar: MainTabBar?
    private var launchscreenView: LaunchscreenView = LaunchscreenView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [containerTab(), cameraTab(), settingsTab()]
        tabBar.isTranslucent = false
        delegate = self
        
        let launchscreenView = LaunchscreenView(frame: view.frame)
        //view.layer.addSublayer(launchscreenView.layer)
        self.launchscreenView = launchscreenView
        handlePreparationNotification()
        customTabBar = tabBar as? MainTabBar
        let offset = UIOffset(horizontal: 0, vertical: -7)
        tabBar.items?.forEach { item in
            item.image = nil
            item.titlePositionAdjustment = offset
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //launchscreenView.animateGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBar?.setupBar()
    }
    
    private func handlePreparationNotification() {
        NotificationCenter.default.addObserver(
            forName: PeparationNotificationName,
            object: nil,
            queue: nil,
            using: { [weak self] notification in
                self?.handlePreparedState(withNofication: notification)
            }
        )
        
    }
    
    private func handlePreparedState(withNofication notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
        UIView.fadeOut(
            view: launchscreenView,
            completion: { [weak self] in
                self?.launchscreenView.removeFromSuperview()
            }
        )
    }
    
    private func containerTab() -> UINavigationController {
        
        let newPhotosVC = ContentViewController<Photo>()
        let newPhotosDS = PhotosDataSource(photoURL: URL(string: UnsplashPhotosAllURL)!)
        newPhotosVC.dataSource = newPhotosDS
        
        let curatedPhotosVC = ContentViewController<Any>()
        let curatedPhotosDS = ContentDataSource<Any>()
        curatedPhotosDS.objects = ["wah", "bah", "dah"]
        curatedPhotosVC.dataSource = curatedPhotosDS
        
        let containerController = ContainerViewController(containedControllers: [        ContainedController("new", newPhotosVC), ContainedController("curated", curatedPhotosVC)])
        let containerNavigationController = NavigationController(rootViewController: containerController)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: "Photos".uppercased(),
            image: nil,
            selectedImage: nil
        )
        containerController.delegate = containerNavigationController
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
