import UIKit
import BurstAPI

class LocationViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!

    fileprivate let location: Location
    
    init(location: Location) {
        self.location = location
        super.init(nibName: LocationViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: MapTableViewCell.className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.separatorStyle = .none
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
    }
    
    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }

}

extension LocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.25
    }
    
}

extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseIdentifier, for: indexPath)
        guard let mapCell = cell as? MapTableViewCell else {
            return cell
        }
        mapCell.configure(forLocation: location)
        return mapCell
    }
    
}
