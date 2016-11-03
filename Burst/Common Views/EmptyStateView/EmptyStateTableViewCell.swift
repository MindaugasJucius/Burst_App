class EmptyStateTableViewCell: UITableViewCell, ReusableView, EmptyStateContainable {

    var emptyStateView: EmptyStateView?
    var emptyStateViewType: EmptyStateViewType = .none {
        didSet {
            configure(emptyStateViewContentView: contentView)
        }
    }
}
