class NavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.isTranslucent = false
        guard let titleView = Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)?.first as? TitleView else {
            return
        }

        rootViewController.navigationItem.titleView = titleView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hidesBarsOnSwipe = true
        
        let width = UIScreen.main.bounds.width
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: 0))
        let progressView = StatusBarProgressView(frame: frame, progress: 0.5)
        //view.addSubview(progressView)
    }

}
