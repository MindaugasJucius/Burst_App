import UIKit

class TitleView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = APPName
        titleLabel.font = AppAppearance.navigationBarFont()
        titleLabel.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(titleLabel.frame)
    }
    
}
