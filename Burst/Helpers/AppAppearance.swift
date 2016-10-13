class AppAppearance: NSObject {
    
    // MARK: - Button sizes
    
    static let ButtonFAIconSize: CGFloat = 20
    
    // MARK: - Text
    
    static let InfoTextFontSize: CGFloat = 12
    
    static func navigationBarFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 20)!
    }
    
    static func cellInfoTextFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: InfoTextFontSize)!
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
    
    // MARK: - Attributed String Helpers
    
    static func faAttributedString(forIcon icon: FAType,
                                    textSize size: CGFloat = AppAppearance.InfoTextFontSize,
                                    textColor color: UIColor = AppAppearance.white) -> NSAttributedString? {
        guard let iconText = icon.text else {
            return nil
        }
        FontLoader.loadFontIfNeeded()
        let iconFont = UIFont(name: FAStruct.FontName, size: size)!
        let iconAttributes = [NSFontAttributeName: iconFont,
                              NSForegroundColorAttributeName: color]
        
        return NSAttributedString(string: iconText, attributes: iconAttributes)
    }
    
    static func infoTextAttributedString(forValue value: String, textColor color: UIColor = AppAppearance.white) -> NSAttributedString {
        let textAttributes = [NSFontAttributeName: AppAppearance.cellInfoTextFont(),
                              NSForegroundColorAttributeName: color]
        return NSAttributedString(string: value, attributes: textAttributes)
    }
    
}
