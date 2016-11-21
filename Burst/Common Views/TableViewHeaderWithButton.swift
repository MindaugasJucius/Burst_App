import UIKit

class TableViewHeaderWithButton: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet weak var leftImageView: UIImageView?
    @IBOutlet private weak var button: InsetButton!
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: - Public
    
    func configure(labelTitle: String, hideButton: Bool = true, hideImage: Bool = true, buttonTitle: String? = nil, onButtonTap: (() -> ())? = nil) {
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = hideButton
        button.onButtonTap = onButtonTap
        label.text = labelTitle.capitalized
        guard hideImage, leftImageView != nil else {
            return
        }
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func initialSetup() {
        contentView.backgroundColor = AppAppearance.tableViewBackground
        label.textColor = AppAppearance.subtitleColor
        label.font = AppAppearance.condensedFont(withSize: .headerTitle)
        label.lineBreakMode = .byWordWrapping
    }
    
    private func setupConstraints() {
        leftImageView?.removeFromSuperview()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 15).isActive = true
    }
    
}
