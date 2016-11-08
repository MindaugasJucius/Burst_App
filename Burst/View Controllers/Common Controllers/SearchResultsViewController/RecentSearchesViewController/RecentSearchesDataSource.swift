fileprivate let SeparatorInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

class RecentSearchesDataSource: NSObject {
    
    private weak var tableView: UITableView!
    fileprivate var recentSearches: [RecentSearch]
    
    init(tableView: UITableView, recentSearches: [RecentSearch]) {
        self.tableView = tableView
        self.recentSearches = recentSearches
        super.init()
    }
    
    func update(forRecentSearches recentSearches: [RecentSearch]) {
        self.recentSearches = recentSearches
        tableView.reloadData()
    }
    
    // MARK: - Delegate helpers
    
    func shouldSelectCell(atIndexPath indexPath: IndexPath) -> Bool {
        return !(tableView.cellForRow(at: indexPath) is EmptyStateTableViewCell)
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
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = AppAppearance.regularFont(withSize: .systemSize)
        cell.separatorInset = SeparatorInsets
        cell.imageView?.image = #imageLiteral(resourceName: "searchFieldIcon")
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

extension RecentSearchesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearches.isEmpty {
            return emptyStateCell(forIndexPath: indexPath)
        } else {
            return recentSearchCell(forIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.isEmpty ? 1 : recentSearches.count
    }
}
