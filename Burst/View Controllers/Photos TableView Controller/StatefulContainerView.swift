enum ContainerViewState {
    case empty
    case normal
}

protocol StatefulContainerView: class {
    
    var state: ContainerViewState { get set }

    func handle(error: Error)
    func configureEmptyState()
    func configureNormalState()
    func configureCommonState()
}

extension StatefulContainerView {
    
    var emptyState: Bool {
        get {
            return state == .empty
        }
    }
    
    func updateView(forState state: ContainerViewState) {
        switch state {
        case .empty:
            configureEmptyState()
        case .normal:
            configureNormalState()
        }
    }
}
