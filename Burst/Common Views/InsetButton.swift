import UIKit

class InsetButton: UIButton {

    override var contentEdgeInsets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 1, left: 15, bottom: 0, right: 15)
        }
        set {
            self.contentEdgeInsets = newValue
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .white
            } else {
                backgroundColor = nil
            }
        }
    }
    
    var onButtonTap: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
        setTitleColor(.black, for: .highlighted)
        
        titleLabel?.font = AppAppearance.regularFont(withSize: .sectionHeaderTitle)
        addTarget(self, action: #selector(tapped(button:)), for: .touchUpInside)
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title?.uppercased(), for: state)
    }

    
    @objc func tapped(button: UIButton) {
        onButtonTap?()
    }
    
}
