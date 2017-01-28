import UIKit

typealias OnContentTap = (Any) -> ()

class ContentCell: UICollectionViewCell {
    
    var dataSourceItem: Any?

    let separatorLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = AppAppearance.lightBlack
        lineView.isHidden = true
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        clipsToBounds = true
        contentView.addSubview(separatorLineView)
        separatorLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
