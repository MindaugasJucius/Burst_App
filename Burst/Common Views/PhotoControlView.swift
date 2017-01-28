import UIKit

let PhotoControlHeight: CGFloat = 40

enum AllowedControlActions {
    case love
    case addToCollection
    case download
    case info
    
    static var defaultConfig: [AllowedControlActions] = [.love, .addToCollection, .download]
    
    var fontAwesomeType: FAType {
        switch self {
        case .love:
            return .FAHeartO
        case .download:
            return .FACloudDownload
        case .addToCollection:
            return .FAPlusCircle
        case .info:
            return .FAInfoCircle
        }
    }
    
}

class PhotoControlView: UIView {

    private var allowedControlActions: [AllowedControlActions] = []
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func update(forConfig config: [AllowedControlActions]) {
        self.allowedControlActions = config
        let buttons: [UIButton] = config.map { [unowned self] in
            let button = UIButton()
            button.setFAIcon(
                icon: $0.fontAwesomeType,
                iconSize: AppAppearance.ButtonFAIconSize,
                forState: .normal
            )
            button.addTarget(self, action: #selector(self.touched(button:)), for: .touchUpInside)
            button.setFATitleColor(color: AppAppearance.white)
            button.setFATitleColor(color: AppAppearance.gray666, forState: .highlighted)
            return button
        }
        buttons.forEach { [unowned self] button in
            self.stackView.addArrangedSubview(button)
        }
    }
    
    func touched(button: UIButton) {
    }
    
    private func configure() {
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
}

class PhotoControlCollectionViewFooter: DefaultFooter {
    
    private var controlView = PhotoControlView(frame: CGRect.zero)
    
    override var dataSourceItem: Any? {
        didSet {
            guard let config = dataSourceItem as? [AllowedControlActions] else { return }
            controlView.update(forConfig: config)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        separatorLineView.isHidden = false
        contentView.addSubview(controlView)
        controlView.fillSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        controlView = PhotoControlView(frame: CGRect.zero)
    }
    
}
