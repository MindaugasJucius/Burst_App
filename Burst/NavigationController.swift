class NavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.translucent = false
        rootViewController.navigationItem.title = APPName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = UIApplication.sharedApplication().statusBarFrame.height + navigationBar.frame.height
        let width = UIScreen.mainScreen().bounds.width
        let progressView = UIProgressView()
        progressView.progressViewStyle = .Bar
        progressView.progressTintColor = AppAppearance.lightBlueAppColor()
        progressView.trackTintColor = .whiteColor()
        progressView.progress = 0.5
        progressView.frame =  CGRect(x: 0, y: height - progressView.frame.height, width: width, height: 0)
        view.addSubview(progressView)
    }

}
