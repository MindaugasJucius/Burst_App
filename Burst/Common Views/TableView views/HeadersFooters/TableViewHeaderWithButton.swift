import UIKit
import AlamofireImage

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
        label.text = labelTitle
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = hideButton
        button.onButtonTap = onButtonTap
        guard hideImage else {
            return
        }
        hideImageView()
    }
    
    func image(withURL url: URL) {
        leftImageView?.af_setImage(withURL: url,
                              placeholderImage: #imageLiteral(resourceName: "Camera"),
                              filter: CircleFilter(),
                              imageTransition: .crossDissolve(0.3),
                              runImageTransitionIfCached: false)
    }
    
    // MARK: - Private
    
    private func initialSetup() {
        label.textColor = AppAppearance.lightGray
        label.font = AppAppearance.regularFont(withSize: .headerTitle, weight: .medium)
        contentView.backgroundColor = AppAppearance.tableViewBackground
        label.lineBreakMode = .byWordWrapping
    }
    
    private func hideImageView() {
        guard leftImageView != nil else {
            return
        }
        leftImageView?.removeFromSuperview()
        label.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 15).isActive = true
    }
    
}
