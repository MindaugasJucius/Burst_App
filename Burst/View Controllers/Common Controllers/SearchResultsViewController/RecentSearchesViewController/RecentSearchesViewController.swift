class RecentSearchesViewController: UIViewController {
    
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    var state: ContainerViewState = .normal
    
    fileprivate var dataSource: RecentSearchesDataSource!
    
    init() {
        super.init(nibName: RecentSearchesViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonState()
        updateView(forState: .empty)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension RecentSearchesViewController: StatefulContainerView {
    
    func configureEmptyState() {
        if let rect = navigationController?.navigationBar.frame {
            tableView.rowHeight = tableView.bounds.height - rect.size.height - UIApplication.shared.statusBarFrame.height
        }
    }
    
    func configureCommonState() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppAppearance.tableViewBackground
        dataSource = RecentSearchesDataSource(tableView: tableView)
        tableView.dataSource = dataSource
        let emptyCellNib = UINib.init(nibName: EmptyStateTableViewCell.className, bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: EmptyStateTableViewCell.reuseIdentifier)
    }
    
    func configureNormalState() {
        tableView.rowHeight = 44
    }
}
