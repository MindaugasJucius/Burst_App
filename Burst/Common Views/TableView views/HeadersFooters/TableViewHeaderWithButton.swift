import UIKit
import AlamofireImage

class TableViewHeaderWithButton: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var button: InsetButton!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var separatorView: UIImageView!
    
    private var labelToImageView: NSLayoutConstraint?
    private var labelToContentView: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: - Public
    
    func configure(labelTitle: String, showImage: Bool = false, buttonTitle: String? = nil, onButtonTap: (() -> ())? = nil) {
        label.text = labelTitle
        button.setTitle(buttonTitle, for: .normal)
        button.isHidden = buttonTitle == nil
        button.onButtonTap = onButtonTap
        separatorView.isHidden = showImage
        updateImageView(visible: showImage)
    }
    
    func label(font: UIFont, textColor: UIColor) {
        label.font = font
        label.textColor = textColor
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
        separatorView.backgroundColor = AppAppearance.silverSandGray
        label.textColor = AppAppearance.lightGray
        label.font = AppAppearance.regularFont(withSize: .headerTitle, weight: .medium)
        contentView.backgroundColor = AppAppearance.tableViewBackground
        label.lineBreakMode = .byWordWrapping
        labelToImageView = label.leadingAnchor.constraint(
            equalTo: leftImageView.trailingAnchor,
            constant: 10)
        labelToContentView = label.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 15)
    }
    
    private func updateImageView(visible: Bool) {
        leftImageView.isHidden = !visible
        labelToImageView?.isActive = visible
        labelToContentView?.isActive = !visible
    }
    
    override func prepareForReuse() {
        leftImageView.image = nil
        labelToImageView?.isActive = false
        labelToContentView?.isActive = false
        leftImageView.isHidden = false
    }
    
}
