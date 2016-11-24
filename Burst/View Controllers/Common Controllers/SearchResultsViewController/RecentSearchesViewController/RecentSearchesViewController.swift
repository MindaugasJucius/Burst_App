class RecentSearchesViewController: UIViewController {
    
    @IBOutlet weak fileprivate var tableView: UITableView!

    fileprivate let dataController = RecentSearchesDataController()
    fileprivate var dataSource: RecentSearchesDataSource!
    
    var state: ContainerViewState = .normal

    var onSearchQuerySelect: ((String) -> ())?
    
    init() {
        super.init(nibName: RecentSearchesViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
        let currentState: ContainerViewState = dataController.recentSearches.isEmpty ? .empty : .normal
        updateView(forState: currentState)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func insert(query: String) {
        let newSearch = RecentSearch(query: query, date: Date())
        dataController.append(search: newSearch)
        updateView(forState: .normal)
        dataSource.update(forRecentSearches: dataController.recentSearches)
    }
    
    fileprivate func clearHistory() {
        dataController.clearHistory()
        updateView(forState: .empty)
        dataSource.update(forRecentSearches: dataController.recentSearches)
    }
}

extension RecentSearchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !dataSource.isEmptyStateCell(atIndexPath: indexPath) else {
            return
        }
        guard !dataSource.isClearHistoryCell(atIndexPath: indexPath) else {
            clearHistory()
            return
        }
        onSearchQuerySelect?(dataController.recentSearches[indexPath.row].query)
    }
    
}

extension RecentSearchesViewController: StatefulContainerView {
    
    func configureEmptyState() {
        if let rect = navigationController?.navigationBar.frame {
            tableView.rowHeight = tableView.bounds.height - rect.size.height - UIApplication.shared.statusBarFrame.height
        }
        tableView.separatorStyle = .none
    }
    
    func configureCommonState() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = AppAppearance.tableViewBackground
        dataSource = RecentSearchesDataSource(tableView: tableView, recentSearches: dataController.recentSearches)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    func configureNormalState() {
        tableView.rowHeight = TableViewCellDefaultHeight
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = AppAppearance.lightBlack
    }
}
