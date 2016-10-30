class SearchResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.tableViewBackground
        guard let emptyStateView = EmptyStateViewFactory.view(forType: .photoSearch) else {
            return
        }
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

}

extension SearchResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
