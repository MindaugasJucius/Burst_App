extension UIViewController {

    static func fromStoryboard(withName name: String? = nil) -> Self? {
        return fromStoryboardHelper(storyboardName: name)
    }
    
    private static func fromStoryboardHelper<U: NSObject>(storyboardName name: String?) -> U? {
        let storyboardName = name ?? U.className
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: storyboardName) as? U else {
            return nil
        }
        return controller
    }
    
}
