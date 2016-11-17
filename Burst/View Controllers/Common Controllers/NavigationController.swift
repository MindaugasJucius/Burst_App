protocol NavigationControllerDelegate: class {
    func update(withProgress progress: Double)
    
}

class NavigationController: UINavigationController {
    
    fileprivate var titleView: TitleView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        let burstTitleView: TitleView? = TitleView.loadFromNib()
        self.titleView = burstTitleView
        rootViewController.navigationItem.titleView = titleView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView?.configure()
        titleView?.beginAnimation()
    }

}

extension NavigationController: NavigationControllerDelegate {
    func update(withProgress progress: Double) {
        titleView?.update(withOffset: progress)
    }
}
