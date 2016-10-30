fileprivate let MinSearchQueryLenght = 3

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var emptyStateView: EmptyStateView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = AppAppearance.tableViewBackground
        guard let emptyStateView = EmptyStateViewFactory.view(forType: .photoSearch) else {
            return
        }
        emptyStateView.frame = view.bounds
        self.emptyStateView = emptyStateView
        view.insertSubview(emptyStateView, aboveSubview: collectionView)
    }
    
}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.characters.count >= MinSearchQueryLenght else {
            return
        }
        emptyStateView.presentActivityIndicator()
    }
}
