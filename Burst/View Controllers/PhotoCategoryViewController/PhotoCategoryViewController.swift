import BurstAPI

fileprivate let PhotoCategorySection = "PhotoCategorySection"

class PhotoCategoryViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private let photoCategories: [PhotoCategory]
    
    init(photoCategories: [PhotoCategory]) {
        self.photoCategories = photoCategories
        print("category vc \(photoCategories.count)")
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
        tableView.rowHeight = CollectionCoverPhotoHeight
    }
    
    fileprivate func configure(containerCell: CollectionViewContainerTableViewCell) {
        containerCell.layout = UICollectionViewFlowLayout.photoCollectionsLayout()
        containerCell.isPagingEnabled = true
        containerCell.sectionItems = categoriesSectionItem()
    }
    
    private func categoriesSectionItem() -> [SectionItem] {
        let sectionItem = SectionItem(sectionTitle: PhotoCategorySection, cellItem: PhotoCategoryCollectionViewCell.self, representedObjects: photoCategories, header: nil, footer: nil)
        return [sectionItem]
    }
    
}

extension PhotoCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewContainerTableViewCell.reuseIdentifier, for: indexPath)
        guard let containerCell = cell as? CollectionViewContainerTableViewCell else {
            return cell
        }
        configure(containerCell: containerCell)
        return containerCell
    }
    
}

extension PhotoCategoryViewController: PhotoInfoContentController {
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }
}
