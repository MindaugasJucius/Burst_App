fileprivate let SeparatorInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

fileprivate let RecentSearchCellReuseIdentifier = "RecentSearchCell"
fileprivate let ClearSearchHistoryCellReuseIdentifier = "ClearSearchHistoryCell"

class RecentSearchesDataSource: NSObject {
    
    private weak var tableView: UITableView!
    fileprivate var recentSearches: [RecentSearch]
    
    init(tableView: UITableView, recentSearches: [RecentSearch]) {
        self.tableView = tableView
        self.recentSearches = recentSearches
        super.init()
        registerViews()
    }
    
    func update(forRecentSearches recentSearches: [RecentSearch]) {
        self.recentSearches = recentSearches
        tableView.reloadData()
    }
    
    private func registerViews() {
        let emptyCellNib = UINib.init(nibName: EmptyStateTableViewCell.className, bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: EmptyStateTableViewCell.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: RecentSearchCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ClearSearchHistoryCellReuseIdentifier)
    }
    
    // MARK: - Delegate helpers
    
    func isEmptyStateCell(atIndexPath indexPath: IndexPath) -> Bool {
        return (tableView.cellForRow(at: indexPath) is EmptyStateTableViewCell)
    }
    
    func isClearHistoryCell(atIndexPath indexPath: IndexPath) -> Bool {
        return tableView.cellForRow(at: indexPath)?.reuseIdentifier == ClearSearchHistoryCellReuseIdentifier
    }
    
    // MARK: - Cell configuration
    
    fileprivate func emptyStateCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.reuseIdentifier, for: indexPath)
        guard let emptyStateCell = cell as? EmptyStateTableViewCell else {
            return cell
        }
        emptyStateCell.emptyStateViewType = .photoSearch
        emptyStateCell.selectionStyle = .none
        return emptyStateCell
    }
    
    fileprivate func recentSearchCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCellReuseIdentifier, for: indexPath)
        let recentSearch = recentSearches[indexPath.row]
        cell.textLabel?.text = recentSearch.query
        cell.imageView?.image = #imageLiteral(resourceName: "searchFieldIcon")
        cell.selectionStyle = .none
        commonAppearance(forCell: cell)
        return cell
    }
    
    fileprivate func clearHistoryCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClearSearchHistoryCellReuseIdentifier, for: indexPath)
        commonAppearance(forCell: cell)
        cell.textLabel?.text = ClearSearchHistory
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    private func commonAppearance(forCell cell: UITableViewCell) {
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = AppAppearance.regularFont(withSize: .systemSize)
        cell.separatorInset = SeparatorInsets
        cell.backgroundColor = .black
    }
}

extension RecentSearchesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearches.isEmpty {
            return emptyStateCell(forIndexPath: indexPath)
        } else {
            if indexPath.row == recentSearches.count {
                return clearHistoryCell(forIndexPath: indexPath)
            }
            return recentSearchCell(forIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.isEmpty ? 1 : recentSearches.count + 1
    }
}
