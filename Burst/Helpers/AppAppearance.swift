enum FontSize: CGFloat {
    case cellText = 12
    case subtitleCellText = 11
    case sectionHeaderTitle = 13
    case headerTitle = 20
    case headerSubtitle = 14
    case iconSize = 9
    case systemSize = 15
}

let TableViewCellDefaultHeight: CGFloat = 44

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
    
    static func italicFont(withSize size: FontSize) -> UIFont {
        return font(withName: "AvenirNext-Italic", fontSize: size)
    }
    
    private static func font(withName name: String, fontSize size: FontSize) -> UIFont {
        let fontSize = size.rawValue
        guard let font = UIFont(name: name, size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
    
    // MARK: - Main gradients
    
    static func mainGradientLayer(withMask mask: CALayer, andFrame frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = AppAppearance.gradientStartColors
        gradientLayer.locations = [0.0, 0.48, 1.0]
        gradientLayer.frame = frame
        gradientLayer.mask = mask
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        return gradientLayer
    }
    
    static let gradientStartColors = [UIColor(hue: 0.582, saturation: 0.676, brightness: 0.992, alpha: 1).cgColor,
                                       UIColor(hue: 0.582, saturation: 1, brightness: 0.748, alpha: 1).cgColor,
                                       UIColor(hue: 0.975, saturation: 1, brightness: 1, alpha: 1).cgColor]
    static let gradientEndColors = [UIColor(hue: 0.975, saturation: 1, brightness: 1, alpha: 1).cgColor,
                                     UIColor(hue: 0.582, saturation: 1, brightness: 0.748, alpha: 1).cgColor,
                                     UIColor(hue: 0.582, saturation: 0.676, brightness: 0.992, alpha: 1).cgColor]
    
    // MARK: - Colors
    
    static let lightBlack = UIColor.colorWithHexString("101010")
    static let lightGray = UIColor.colorWithHexString("EBEDEE")
    
    static let darkBlue = UIColor.colorWithHexString("0465C2")
    static let lightBlue = UIColor.colorWithHexString("469EF4")
    
    static let darkRed = UIColor.colorWithHexString("c0392b")
    static let lightRed = UIColor.colorWithHexString("e74c3c")
    
    static let white = UIColor.white
    
    static let subtitleColor = UIColor.colorWithHexString("999999")
    static let tableViewBackground = UIColor.black
    
    // MARK: - Attributed String Helpers
    
    static func faAttributedString(forIcon icon: FAType,
                                    textSize size: FontSize = .cellText,
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
                                         textSize size: FontSize = .cellText,
                                         textColor color: UIColor = AppAppearance.white) -> NSAttributedString {
        let textAttributes = [NSFontAttributeName: AppAppearance.regularFont(withSize: size),
                              NSForegroundColorAttributeName: color]
        return NSAttributedString(string: value, attributes: textAttributes)
    }
    
    // MARK: - SearchBar appearance
    
    static func applyLightBlackStyle(forSearchBar searchBar: UISearchBar) {
        searchBar.searchBarStyle = .minimal
        let image = UIImage.image(
            fromColor: AppAppearance.lightBlack,
            withSize: CGSize(width: 28, height: 28)
        )
        searchBar.tintColor = .white
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
        searchBar.setImage(#imageLiteral(resourceName: "searchFieldClearIcon"), for: .clear, state: .normal)
        searchBar.setImage(#imageLiteral(resourceName: "searchFieldClearIconHighlighted"), for: .clear, state: .highlighted)
        searchBar.setImage(#imageLiteral(resourceName: "searchFieldIcon"), for: .search, state: .normal)
        searchBar.setImage(#imageLiteral(resourceName: "searchFieldIcon"), for: .search, state: .highlighted)
        searchBar.setSearchFieldBackgroundImage(
            image?.af_imageRounded(withCornerRadius: 4),
            for: .normal
        )
        let searchBarTextfield = searchBar.subview(ofType: UITextField.self)
        guard let textField = searchBarTextfield else {
            return
        }
        textField.keyboardAppearance = .dark
        textField.textColor = .white
        let placeholderAttributes = [NSForegroundColorAttributeName: AppAppearance.subtitleColor]
        textField.font = AppAppearance.regularFont(withSize: .systemSize)
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: Search, attributes: placeholderAttributes)
        textField.attributedPlaceholder = attributedPlaceholder
    }
}
