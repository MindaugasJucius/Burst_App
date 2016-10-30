class EmptyStateView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var emptyStateViewType: EmptyStateViewType = .photoSearch
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = AppAppearance.condensedFont(withSize: .SystemSize)
        label.textColor = AppAppearance.white
        backgroundColor = AppAppearance.tableViewBackground
    }
    
    func configure(forType type: EmptyStateViewType) {
        label.text = type.translation
        imageView.image = type.image
    }
    
}
