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
        configureTableView()
    }

    private func registerViews() {
        let collectionsCellNib = UINib(nibName: CollectionViewContainerTableViewCell.className, bundle: nil)
        tableView?.register(collectionsCellNib, forCellReuseIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier)
    }
    
    private func configureTableView() {
        registerViews()
        tableView.dataSource = self
    }
    
    private func configure(containerCell: CollectionViewContainerTableViewCell) {
        
    }
    
}

extension PhotoCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let containerCell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier, for: indexPath)
        
    }
    
}

extension PhotoCategoryViewController: PhotoInfoContentController {
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
}
