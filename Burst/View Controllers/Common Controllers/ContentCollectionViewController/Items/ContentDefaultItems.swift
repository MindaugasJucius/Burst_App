import UIKit

class DefaultHeader: ContentCell {
    
}

class DefaultFooter: ContentCell {
    
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