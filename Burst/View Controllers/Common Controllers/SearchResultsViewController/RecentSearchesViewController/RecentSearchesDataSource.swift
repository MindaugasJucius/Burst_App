class RecentSearchesDataSource: NSObject {

    private weak var tableView: UITableView!
    fileprivate var searchQueries: [String] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - Cell configuration
    
    fileprivate func emptyStateCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateTableViewCell.reuseIdentifier, for: indexPath)
        guard let emptyStateCell = cell as? EmptyStateTableViewCell else {
            return cell
        }
        emptyStateCell.emptyStateViewType = .photoSearch
        return emptyStateCell
    }
    
}

extension RecentSearchesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchQueries.isEmpty {
            return emptyStateCell(forIndexPath: indexPath)
        } else {
            return tableView.cellForRow(at: indexPath)!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
