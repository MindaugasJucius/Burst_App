protocol EmptyStateContainer: class {
    
    var emptyStateView: EmptyStateView? { get set }
    var emptyStateViewType: EmptyStateViewType { get set }
    var substring: String? { get set }
}

extension EmptyStateContainer {
    
    func configure(emptyStateViewContentView view: UIView, substring: String?) {
        emptyStateView?.removeFromSuperview()
        guard let newStateView = EmptyStateViewFactory.view(forType: emptyStateViewType, substring: substring) else {
            return
        }
        newStateView.frame = view.bounds
        newStateView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(newStateView)
        emptyStateView = newStateView
        emptyStateView?.addSeparator()
    }
}
