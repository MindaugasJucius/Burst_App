class NavigationController: UINavigationController {
    
    private var titleView: TitleView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.isTranslucent = false
        guard let titleView = Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)?.first as? TitleView else {
            return
        }
        self.titleView = titleView
        rootViewController.navigationItem.titleView = titleView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView?.configure()
    }

}
