enum ContainerViewState {
    case empty
    case normal
}

protocol StatefulContainerView: class {
    
    var state: ContainerViewState { get set }

    func configureEmptyState()
    func configureNormalState()
    func configureCommonState()
}

extension StatefulContainerView {

    func configureEmptyState() { }
    func configureNormalState() { }
    
    func updateView(forState state: ContainerViewState) {
        switch state {
        case .empty:
            configureEmptyState()
        case .normal:
            configureNormalState()
        }
    }
    
    var emptyState: Bool {
        get {
            return state == .empty
        }
    }
    
}

extension StatefulContainerView where Self: UIViewController {
    
    func handle(error: Error) {
        self.handle(error: error)
    }
}
