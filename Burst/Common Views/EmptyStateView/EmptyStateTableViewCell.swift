class EmptyStateTableViewCell: UITableViewCell, ReusableView, EmptyStateContainer {

    var emptyStateView: EmptyStateView?
    var emptyStateViewType: EmptyStateViewType = .none {
        didSet {
            configure(emptyStateViewContentView: contentView)
        }
    }
}
