import UIKit

final class MainTabBarViewController: UITabBarController {

    fileprivate let imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [containerTab(), cameraTab(), settingsTab()]
        tabBar.isTranslucent = false
        tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func containerTab() -> UINavigationController {
        let controller = ContainerViewController(nibName: "ContainerViewController", bundle: nil)
        let containerNavigationController = NavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "GalleryDisabled"),
            selectedImage: UIImage(named: "GallerySelected")
        )
        containerNavigationController.tabBarItem.imageInsets = imageInsets
        return containerNavigationController
    }
    
    fileprivate func cameraTab() -> UINavigationController {
        let controller = UIViewController()
        let containerNavigationController = UINavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "CameraDisabled"),
            selectedImage: UIImage(named: "CameraSelected")
        )
        containerNavigationController.tabBarItem.imageInsets = imageInsets
        return containerNavigationController
    }
    
    fileprivate func settingsTab() -> UINavigationController {
        let controller = UIViewController()
        let containerNavigationController = UINavigationController(rootViewController: controller)
        containerNavigationController.tabBarItem  = UITabBarItem(
            title: nil,
            image: UIImage(named: "SettingsDisabled"),
            selectedImage: UIImage(named: "SettingsSelected")
        )
        containerNavigationController.tabBarItem.imageInsets = imageInsets
        return containerNavigationController
    }

}
