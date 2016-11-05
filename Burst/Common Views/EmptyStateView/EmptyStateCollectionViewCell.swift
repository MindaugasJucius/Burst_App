class EmptyStateCollectionViewCell: UICollectionViewCell, ReusableView, EmptyStateContainer {

    var substring: String?
    var emptyStateView: EmptyStateView?
    var emptyStateViewType: EmptyStateViewType = .none {
        didSet {
            configure(emptyStateViewContentView: contentView, substring: substring)
        }
    }
}
