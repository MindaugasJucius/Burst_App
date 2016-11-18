import UIKit

class TableViewHeaderWithButton: UITableViewHeaderFooterView, ReusableView {

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var label: UILabel!
    private var onButtonTap: (() -> ())?
    
    override func awakeFromNib() {
        label.textColor = AppAppearance.subtitleColor
        label.font = AppAppearance.condensedFont(withSize: .headerTitle)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppAppearance.regularFont(withSize: .headerSubtitle)
        contentView.backgroundColor = AppAppearance.tableViewBackground
        button.addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
    }
    
    func configure(labelTitle: String, hideButton: Bool = true, buttonTitle: String? = nil, onButtonTap: (() -> ())? = nil) {
        button.setTitle(buttonTitle?.uppercased(), for: .normal)
        button.isHidden = hideButton
        self.onButtonTap = onButtonTap
        label.text = labelTitle.capitalized
    }
    
    @objc func tapped(button: UIButton) {
        onButtonTap?()
    }
    
}
