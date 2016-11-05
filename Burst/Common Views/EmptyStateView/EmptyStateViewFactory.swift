enum EmptyStateViewType {
    case photoSearch
    case photosTable
    case noSearchResults
    case none
    
    var translation: String {
        switch self {
        case .photoSearch:
            return "Enter a keyword to search for photos (e.g. 'city')"
        case .noSearchResults:
            return "No results for %@. Try other keywords?"
        case .photosTable:
            return "No photos. Try again?"
        default:
            return ""
        }
    }

}

class EmptyStateViewFactory: NSObject {
    
    class func view(forType type: EmptyStateViewType, substring: String?) -> EmptyStateView? {
        let emptyStateView: EmptyStateView? = EmptyStateView.loadFromNib()
        if let substring = substring {
            emptyStateView?.attributedString = attributedString(forType: type, substring: substring)
        } else {
            emptyStateView?.attributedString = NSAttributedString(string: type.translation)
        }
        return emptyStateView
    }
    
    class func attributedString(forType type: EmptyStateViewType, substring: String) -> NSAttributedString {
        let string = String(format: type.translation, substring)
        let attributedString = NSMutableAttributedString(string: string)
        let rangeOfSubstring = (string as NSString).range(of: substring)
        let attributes = [NSForegroundColorAttributeName: AppAppearance.lightGray,
                          NSFontAttributeName : AppAppearance.italicFont(withSize: .systemSize)]
        attributedString.addAttributes(attributes, range: rangeOfSubstring)
        return attributedString
    }
    
}
