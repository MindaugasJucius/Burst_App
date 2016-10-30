enum EmptyStateViewType {
    case photoSearch
    
    var translation: String {
        switch self {
        case .photoSearch:
            return SearchPhotos
        }
    }
    
    var image: UIImage {
        switch self {
        case .photoSearch:
            return #imageLiteral(resourceName: "imageIcon")
        }
    }
    
}

class EmptyStateViewFactory: NSObject {
    
    class func view(forType type: EmptyStateViewType) -> EmptyStateView? {
        let emptyStateView: EmptyStateView? = EmptyStateView.loadFromNib()
        emptyStateView?.configure(forType: type)
        return emptyStateView
    }
    
}
