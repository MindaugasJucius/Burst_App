import UIKit
import BurstAPI

class ContentViewController: UIViewController {

    var dataSource: ContentDataSource!
    fileprivate var collectionView: UICollectionView!
    
    var collectionViewLayout: UICollectionViewLayout? {
        didSet {
            guard let layout = collectionViewLayout else {
                return
            }
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func refreshControl() -> UIRefreshControl {
        let refresher = UIRefreshControl()
        refresher.tintColor = .white
        refresher.addTarget(self, action: #selector(handleRefresh(control:)), for: .valueChanged)
        return refresher
    }
    
    @objc func handleRefresh(control: UIRefreshControl) {
        dataSource.handleRefresh(control: control)
    }

}

// MARK: - CollectionView configuration

extension ContentViewController {

    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.addSubview(refreshControl())
        dataSource.collectionView = collectionView
        registerDataSourceItems()
        collectionView.alwaysBounceVertical = true
        collectionView.fillSuperview()
        collectionView.addInfiniteScroll(
            handler: { [unowned self] collectionView in
                self.dataSource.handleInfiniteScroll(forCollectionView: collectionView)
            }
        )
        collectionView.infiniteScrollIndicatorStyle = .white
        collectionView.infiniteScrollTriggerOffset = collectionView.bounds.height * 2
    }
    
    fileprivate func registerDataSourceItems() {
        guard let dataSource = dataSource else {
            return
        }
        dataSource.cellClasses().forEach { [unowned self] cellType in
            self.collectionView.register(cellType, forCellWithReuseIdentifier: cellType.className)
        }
        
        if let footers = dataSource.footerClasses() {
            footers.forEach { [unowned self] footerType in
                self.collectionView.register(footerType, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerType.className)
            }
        }

        if let headers = dataSource.headerClasses() {
            headers.forEach { [unowned self] headerType in
                self.collectionView.register(headerType, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerType.className)
            }
        }
        collectionView.reloadData()
    }
    
}

extension ContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSource.referenceSize(forItemAtPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return dataSource.referenceSize(forHeaderInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return dataSource.referenceSize(forFooterInSection: section)
    }
    
}
