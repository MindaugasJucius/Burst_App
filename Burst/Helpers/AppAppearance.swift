enum FontSize: CGFloat {
    case CellText = 12
    case SubtitleCellText = 11
    case SectionHeaderTitle = 13
    case HeaderTitle = 20
    case HeaderSubtitle = 14
    case IconSize = 9
}


class AppAppearance: NSObject {
    
    // MARK: - Button sizes
    
    static let ButtonFAIconSize: CGFloat = 20
    
    // MARK: - Text
    
    static func regularFont(withSize size: FontSize) -> UIFont {
        return font(withName: "AvenirNext-Regular", fontSize: size)
    }
    
    static func condensedFont(withSize size: FontSize) -> UIFont {
        return font(withName: "AvenirNextCondensed-Regular", fontSize: size)
    }
    
    private static func font(withName name: String, fontSize size: FontSize) -> UIFont {
        let fontSize = size.rawValue
        guard let font = UIFont(name: name, size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    // MARK: - Colors
    
    static let lightBlack = UIColor.colorWithHexString("101010")
    
    static let darkBlue = UIColor.colorWithHexString("124399")
    static let lightBlue = UIColor.colorWithHexString("4487C9")
    
    static let darkRed = UIColor.colorWithHexString("c0392b")
    static let lightRed = UIColor.colorWithHexString("e74c3c")
    
    static let white = UIColor.white
    
    static let subtitleColor = UIColor.colorWithHexString("999999")
    static let tableViewBackground = UIColor.black
    
    // MARK: - Attributed String Helpers
    
    static func faAttributedString(forIcon icon: FAType,
                                    textSize size: FontSize = .CellText,
                                    textColor color: UIColor = AppAppearance.white) -> NSAttributedString? {
        guard let iconText = icon.text else {
            return nil
        }
        FontLoader.loadFontIfNeeded()
        let iconFont = UIFont(name: FAStruct.FontName, size: size.rawValue)!
        let iconAttributes = [NSFontAttributeName: iconFont,
                              NSForegroundColorAttributeName: color]
        
        return NSAttributedString(string: iconText, attributes: iconAttributes)
    }
    
    static func infoTextAttributedString(forValue value: String,
                                         textSize size: FontSize = .CellText,
                                         textColor color: UIColor = AppAppearance.white) -> NSAttributedString {
        let textAttributes = [NSFontAttributeName: AppAppearance.regularFont(withSize: size),
                              NSForegroundColorAttributeName: color]
        return NSAttributedString(string: value, attributes: textAttributes)
    }    
}
