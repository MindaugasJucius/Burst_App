class EmptyStateView: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    private var emptyStateViewType: EmptyStateViewType = .photoSearch
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        label.font = AppAppearance.condensedFont(withSize: .SystemSize)
        label.textColor = AppAppearance.white
        backgroundColor = AppAppearance.tableViewBackground
        containerView.backgroundColor = AppAppearance.tableViewBackground
    }
    
    func configure(forType type: EmptyStateViewType) {
        label.text = type.translation
        imageView.image = type.image
    }
    
    func hideEmptyStateView() {
        UIView.fadeOut(view: self, completion: nil)
        activityIndicator.stopAnimating()
    }
    
    func presentActivityIndicator() {
        activityIndicator.startAnimating()
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.containerView.alpha = 0
            },
            completion: nil
        )
    }
}
