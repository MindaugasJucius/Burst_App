class AppAppearance: NSObject {
    
    static let sharedAppearance = AppAppearance()
    
    // MARK: - Text
    
    static func navigationBarFont() -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: 20)!
    }
    
    // MARK: - Colors
    
    static func darkBlueAppColor() -> UIColor {
        return UIColor.colorWithHexString("124399")
    }
    
    static func lightBlueAppColor() -> UIColor {
        return UIColor.colorWithHexString("4487C9")
    }
    
}
