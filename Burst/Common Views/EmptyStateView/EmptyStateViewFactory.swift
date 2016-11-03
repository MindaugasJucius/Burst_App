enum EmptyStateViewType {
    case photoSearch
    case photosTable
    case none
    
    var translation: String {
        switch self {
        case .photoSearch:
            return SearchPhotos
        case .photosTable:
            return "No photos. Try again?"
        default:
            return ""
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
