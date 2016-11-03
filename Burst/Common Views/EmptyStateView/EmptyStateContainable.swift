protocol EmptyStateContainable: class {
    
    var emptyStateView: EmptyStateView? { get set }
    var emptyStateViewType: EmptyStateViewType { get set }
    
}

extension EmptyStateContainable {
    
    func configure(emptyStateViewContentView view: UIView) {
        emptyStateView?.removeFromSuperview()
        guard let newStateView = EmptyStateViewFactory.view(forType: emptyStateViewType) else {
            return
        }
        newStateView.frame = view.bounds
        newStateView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(newStateView)
        emptyStateView = newStateView
    }
}
