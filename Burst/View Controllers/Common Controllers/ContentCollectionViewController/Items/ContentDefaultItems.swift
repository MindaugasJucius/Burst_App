import UIKit

class DefaultHeader: DefaultContentCell {
    
    override func setupViews() {
        super.setupViews()
        label.text = "Header Cell"
        label.textAlignment = .center
    }
}

class DefaultFooter: DefaultContentCell {
    
    override func setupViews() {
        super.setupViews()
        label.text = "Footer Cell"
        label.textAlignment = .center
    }
}

class DefaultContentCell: ContentCell {
    
    override var dataSourceItem: Any? {
        didSet {
            if let text = dataSourceItem as? String {
                label.text = text
            }
        }
    }
    
    let label = UILabel()
    
    override func setupViews() {
        super.setupViews()
        contentView.backgroundColor = .white
        addSubview(label)
        label.numberOfLines = 0
        label.font = AppAppearance.regularFont(withSize: .seventeen)
        label.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 15, rightConstant: 15)
    }
    
}
