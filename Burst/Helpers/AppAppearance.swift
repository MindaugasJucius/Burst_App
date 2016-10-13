class AppAppearance: NSObject {
    
    static let sharedAppearance = AppAppearance()
    
    // MARK: - Text
    
    static func navigationBarFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 20)!
    }
    
    static func headerViewTitleFont() -> UIFont {
        return UIFont(name: "AvenirNextCondensed-Regular", size: 20)!
    }
    
    static func headerViewSubtitleFont() -> UIFont {
        return UIFont(name: "AvenirNextCondensed-Regular", size: 14)!
    }
    
    // MARK: - Colors
    
    static let darkBlue = UIColor.colorWithHexString("124399")
    static let lightBlue = UIColor.colorWithHexString("4487C9")
    
    static let darkRed = UIColor.colorWithHexString("c0392b")
    static let lightRed = UIColor.colorWithHexString("e74c3c")
    
    static let white = UIColor.white
    static let subtitleColor = UIColor.colorWithHexString("999999")
    
}
