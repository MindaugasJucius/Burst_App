import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let mainTabBarController = MainTabBarViewController()
        window?.rootViewController = mainTabBarController
        updateNavigationBarAppearance()
        updateTabBarAppearance()
        return true
    }
    
    // MARK: - Private state handlers
    
    private func updateTabBarAppearance() {
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = AppAppearance.lightBlueAppColor()
    }

    private func updateNavigationBarAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.whiteColor(),
             NSFontAttributeName : AppAppearance.navigationBarFont()]
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().setBackgroundImage(
                                                        UIImage(),
                                                        forBarPosition: .Any,
                                                        barMetrics: .Default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
    }

}

