import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let mainTabBarController = MainTabBarViewController()
        window?.rootViewController = mainTabBarController
        updateNavigationBarAppearance()
        updateTabBarAppearance()
        return true
    }
    
    // MARK: - Private state handlers
    
    fileprivate func updateTabBarAppearance() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = AppAppearance.lightBlueAppColor()
    }

    fileprivate func updateNavigationBarAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.white,
             NSFontAttributeName : AppAppearance.navigationBarFont()]
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(
                                                        UIImage(),
                                                        for: .any,
                                                        barMetrics: .default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
    }

}

