import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        updateNavigationBarAppearance()
        updateTabBarAppearance()
        return true
    }
    
    // MARK: - Private state handlers
    
    private func updateTabBarAppearance() {
        let attributes = [NSFontAttributeName: AppAppearance.regularFont(withSize: .CellText)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBar.appearance().shadowImage = UIImage()
    }

    private func updateNavigationBarAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.white,
             NSFontAttributeName : AppAppearance.regularFont(withSize: .HeaderTitle)]
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
    }

}

