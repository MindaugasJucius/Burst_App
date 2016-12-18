import BurstAPI

class PhotoCategoryViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private let photoCategories: [PhotoCategory]
    
    init(photoCategories: [PhotoCategory]) {
        self.photoCategories = photoCategories
        super.init(nibName: PhotoCategoryViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension PhotoCategoryViewController: PhotoInfoContentController {
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
    
}
