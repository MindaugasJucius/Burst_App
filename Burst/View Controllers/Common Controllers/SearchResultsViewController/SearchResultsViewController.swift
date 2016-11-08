import BurstAPI
import Alamofire

fileprivate let InteritemSpacing: CGFloat = 1

enum SearchType {
    case photos
    case collections
    case users
    case noResults
    
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
    @IBOutlet fileprivate weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var acitivityIndicatorContainerView: UIView!
    
    fileprivate var isActivityIndicatorVisible: Bool = false
    fileprivate var searchDelayer: Timer?
    fileprivate var searchType: SearchType
    fileprivate var searchRequest: DataRequest?
    fileprivate var currentSearchPage: Int = 1
    fileprivate var searchQuery: String = ""
    fileprivate var fetchedResults: [Photo] = []
    fileprivate var indexPaths: [IndexPath] = []
    fileprivate var currentItemCount: Int = 0
    fileprivate var searchResults: SearchResults<Photo>? {
        didSet {
            guard let results = searchResults else {
                return
            }
            hideActivityIndicator()
            updateCollectionView(forSearchResults: results.results)
        }
    }
    
    var state: ContainerViewState = .normal {
        didSet {
            if oldValue != state {
                collectionViewLayout.invalidateLayout()
                updateView(forState: state)
            }
        }
    }
    
    var onSearchOccurence: ((String) -> ())?
    
    init(searchType: SearchType) {
        self.searchType = searchType
        super.init(nibName: SearchResultsViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
        updateView(forState: .normal)
    }
    
    // MARK: - Activity indicator appearance
    
    func showActivityIndicator() {
        guard !isActivityIndicatorVisible else {
            return
        }
        isActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        UIView.fadeIn(view: acitivityIndicatorContainerView, completion: nil)
    }
    
    func hideActivityIndicator() {
        guard isActivityIndicatorVisible else {
            return
        }
        isActivityIndicatorVisible = false
        UIView.fadeOut(
            view: acitivityIndicatorContainerView,
            completion: { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        )
    }
    
    // MARK: - Collection View preparation
    
    fileprivate func prepareForRetrieval() {
        collectionView.addInfiniteScroll { [weak self] collectionView in
            guard let strongSelf = self else {
                    return
            }
            strongSelf.currentSearchPage = strongSelf.currentSearchPage + 1
            strongSelf.fetchResults(forQuery: strongSelf.searchQuery, page: strongSelf.currentSearchPage)
        }
        collectionView.setShouldShowInfiniteScrollHandler { [weak self] collectionView in
            guard let strongSelf = self,
                let searchResults = strongSelf.searchResults else {
                    return false
            }
            return searchResults.results.count != 0 &&
                strongSelf.currentSearchPage != searchResults.totalPages
        }
    }
    
    fileprivate func registerViews() {
        let cellNib = UINib.init(nibName: PhotoSearchResultCollectionViewCell.className,
                                 bundle: nil)
        collectionView.register(cellNib,
                                forCellWithReuseIdentifier: PhotoSearchResultCollectionViewCell.reuseIdentifier)
        
        let emptyCellNib = UINib.init(nibName: EmptyStateCollectionViewCell.className,
                                      bundle: nil)
        collectionView.register(emptyCellNib,
                                forCellWithReuseIdentifier: EmptyStateCollectionViewCell.reuseIdentifier)
    }
    
    // MARK: - Cell config
    
    fileprivate func photoCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSearchResultCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let resultsCell = cell as? PhotoSearchResultCollectionViewCell else {
            return cell
        }
        resultsCell.configure(forPhoto: fetchedResults[indexPath.row])
        return resultsCell
    }
    
    fileprivate func emptyStateCell(forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyStateCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let emptyStateCell = cell as? EmptyStateCollectionViewCell else {
            return cell
        }
        if searchQuery.characters.isEmpty {
            emptyStateCell.emptyStateViewType = .photoSearch
        } else {
            emptyStateCell.substring = searchQuery
            emptyStateCell.emptyStateViewType = .noSearchResults
        }
        
        return emptyStateCell
    }
    
    // MARK: - Collection view housekeeping
    
    private func updateCollectionView(forSearchResults results: [Photo]) {
        var currentIndexPaths = [IndexPath]()
        var indexPathsToDelete = [IndexPath]()
        var cellCount = 0
        var newState: ContainerViewState = .normal
        if results.isEmpty { // no results - delete previous items and show empty cell
            newState = .empty
            fetchedResults = []
            indexPathsToDelete = indexPaths
            indexPaths = []
            currentIndexPaths.append(IndexPath(item: 0, section: 0))
            cellCount = currentIndexPaths.count
        } else if currentSearchPage == 1 { // new search - delete previous items + show new results
            newState = .normal
            fetchedResults = results
            indexPathsToDelete = indexPaths
            indexPaths = []
            currentIndexPaths = indexPaths(startingFrom: currentIndexPaths.count,
                                           to: results.count)
            cellCount = results.count
        } else { // continuation of old search query - append results
            let allItemsCount = fetchedResults.count + results.count
            currentIndexPaths = indexPaths(startingFrom: fetchedResults.count,
                                           to: allItemsCount)
            cellCount = allItemsCount
            fetchedResults.append(contentsOf: results)
        }
        
        collectionView.performBatchUpdates(
            { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if !indexPathsToDelete.isEmpty {
                    strongSelf.currentItemCount = 0
                    strongSelf.collectionView.deleteItems(at: indexPathsToDelete)
                }
                strongSelf.currentItemCount = cellCount
                strongSelf.state = newState
                strongSelf.collectionView.insertItems(at: currentIndexPaths)
            },
            completion: { [weak self] finished in
                self?.indexPaths.append(contentsOf: currentIndexPaths)
                self?.collectionView.finishInfiniteScroll()
            }
        )
    }
    
    private func indexPaths(startingFrom: Int, to: Int) -> [IndexPath] {
        var newPaths: [IndexPath] = []
        for index in startingFrom...to-1 {
            let indexPath = IndexPath(item: index, section: 0)
            newPaths.append(indexPath)
        }
        return newPaths
    }
    
    // MARK: - Results fetching
    
    @objc func search(withDelayer delayer: Timer) {
        guard let query = delayer.userInfo as? String else {
            return
        }
        searchQuery = query
        currentSearchPage = 1
        onSearchOccurence?(query)
        fetchResults(forQuery: query)
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
    }

}

extension SearchResultsViewController: StatefulContainerView {
    
    func configureEmptyState() {
        let cellSize = CGSize(width: UIScreen.main.bounds.width,
                              height: collectionView.bounds.height)
        collectionViewLayout.itemSize = cellSize
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
    }

    func configureNormalState() {
        let screenWidth = UIScreen.main.bounds.width
        let paddingSpace = (searchType.itemsPerRow + 1)
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem = availableWidth / searchType.itemsPerRow
        let cellSize = CGSize(width: widthPerItem, height: widthPerItem)
        collectionViewLayout.itemSize = cellSize
        collectionViewLayout.minimumInteritemSpacing = InteritemSpacing
        collectionViewLayout.minimumLineSpacing = InteritemSpacing * 2
    }
    
    func configureCommonState() {
        prepareForRetrieval()
        registerViews()
        automaticallyAdjustsScrollViewInsets = false
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        acitivityIndicatorContainerView.backgroundColor = .black
        acitivityIndicatorContainerView.alpha = 0
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = AppAppearance.tableViewBackground
        collectionView.dataSource = self
        collectionView.infiniteScrollIndicatorStyle = .white
    }
}

extension SearchResultsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !fetchedResults.isEmpty else {
            return emptyStateCell(forIndexPath: indexPath)
        }
        return photoCell(forIndexPath: indexPath)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            searchText.characters.count > 0, searchQuery != searchText else {
            return
        }
        if let searchDelayer = searchDelayer {
            searchDelayer.invalidate()
        }
        showActivityIndicator()
        searchDelayer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(search(withDelayer:)),
            userInfo: searchText,
            repeats: false
        )
    }
}
