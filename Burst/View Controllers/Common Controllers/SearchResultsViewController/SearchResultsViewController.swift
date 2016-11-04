import BurstAPI
import Alamofire

fileprivate let MinSearchQueryLenght = 3
fileprivate let InteritemSpacing: CGFloat = 1

enum SearchType {
    case photos
    case collections
    case users
    
    var itemsPerRow: CGFloat {
        switch self {
        case .photos:
            return 3
        default:
            return 1
        }
    }
    
}

class SearchResultsViewController: UIViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var searchType: SearchType
    fileprivate var emptyStateView: EmptyStateView?
    fileprivate var searchRequest: DataRequest?
    fileprivate var currentSearchPage: Int = 1
    fileprivate var searchQuery: String?
    fileprivate var fetchedResults: [Photo] = []
    fileprivate var searchResults: SearchResults<Photo>? {
        didSet {
            guard let results = searchResults,
                results.results.count > 0 else {
                emptyStateView?.presentEmptyStateView()
                return
            }
            updateCollectionView(forSearchResults: results.results)
            emptyStateView?.hideEmptyStateView()
        }
    }
    
    init(searchType: SearchType) {
        self.searchType = searchType
        super.init(nibName: SearchResultsViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let emptyStateView = EmptyStateViewFactory.view(forType: .photoSearch) else {
            return
        }
        emptyStateView.frame = view.bounds
        self.emptyStateView = emptyStateView
        view.insertSubview(emptyStateView, aboveSubview: collectionView)
        prepareCollectionView()
    }
    
    // MARK: - Collection View preparation
    
    private func prepareCollectionView() {
        collectionView.backgroundColor = AppAppearance.tableViewBackground
        let cellName = PhotoSearchResultCollectionViewCell.className
        let cellNib = UINib.init(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        collectionView.dataSource = self
        collectionView.collectionViewLayout = prepareLayout()
        collectionView.infiniteScrollIndicatorStyle = .white
        collectionView.addInfiniteScroll { [weak self] collectionView in
            guard let strongSelf = self,
                let query = strongSelf.searchQuery else {
                return
            }
            strongSelf.currentSearchPage = strongSelf.currentSearchPage + 1
            strongSelf.fetchResults(forQuery: query, page: strongSelf.currentSearchPage)
        }
        collectionView.setShouldShowInfiniteScrollHandler { [weak self] collectionView in
            guard let strongSelf = self,
                let searchResults = strongSelf.searchResults else {
                return false
            }
            return searchResults.results.count != 0 ||
                strongSelf.currentSearchPage != searchResults.totalPages
        }
    }
    
    func prepareLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let paddingSpace = (searchType.itemsPerRow + 1)
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem = availableWidth / searchType.itemsPerRow
        let cellSize = CGSize(width: widthPerItem, height: widthPerItem)
        layout.itemSize = cellSize
        layout.minimumInteritemSpacing = InteritemSpacing
        layout.minimumLineSpacing = InteritemSpacing * 2
        return layout
    }
    
    // MARK: - Results fetching
    
    private func updateCollectionView(forSearchResults results: [Photo]) {
        var indexPaths = [IndexPath]()
        let previousCount = fetchedResults.count
        var currentCount = previousCount

        results.forEach { _ in
            let indexPath = IndexPath(item: currentCount, section: 0)
            indexPaths.append(indexPath)
            currentCount = currentCount + 1
        }
        fetchedResults.append(contentsOf: results)
        collectionView.performBatchUpdates(
            { [weak self] in
                self?.collectionView.insertItems(at: indexPaths)
            },
            completion: { [weak self] finished in
                self?.collectionView.finishInfiniteScroll()
            }
        )
    }
    
    fileprivate func fetchResults(forQuery query: String, page: Int = 1) {
        if let previousSearch = searchRequest {
            previousSearch.cancel()
        }
        searchRequest = UnsplashSearch.photos(
            forQuery: query,
            resultsPage: page,
            success: { [weak self] results in
                self?.searchRequest = nil
                self?.searchResults = results
            },
            failure: { [weak self] error in
                self?.searchRequest = nil
                self?.searchResults = nil
                print(error.localizedDescription)
            }
        )
        emptyStateView?.presentActivityIndicator()
    }

}

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSearchResultCollectionViewCell.className, for: indexPath)
        guard let resultsCell = cell as? PhotoSearchResultCollectionViewCell else {
            return cell
        }
        resultsCell.configure(forPhoto: fetchedResults[indexPath.row])
        return resultsCell
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.characters.count >= MinSearchQueryLenght else {
            return
        }
        fetchedResults = []
        collectionView.reloadData()
        currentSearchPage = 1
        searchQuery = searchText
        fetchResults(forQuery: searchText)
    }
}
