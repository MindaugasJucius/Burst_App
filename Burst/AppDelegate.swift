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
        let attributes = [NSFontAttributeName: AppAppearance.regularFont(withSize: .cellText)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }

    private func updateNavigationBarAppearance() {
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.white,
             NSFontAttributeName : AppAppearance.regularFont(withSize: .headerTitle)]
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        let barButtonAttributes = [NSForegroundColorAttributeName : UIColor.white,
                                   NSFontAttributeName : AppAppearance.regularFont(withSize: .systemSize)]
        let highlightedBarButtonAttributes = [NSForegroundColorAttributeName : AppAppearance.subtitleColor,
                                   NSFontAttributeName : AppAppearance.regularFont(withSize: .systemSize)]
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).setTitleTextAttributes(barButtonAttributes, for: .normal)
        (UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])).setTitleTextAttributes(highlightedBarButtonAttributes, for: .highlighted)
    }
}

