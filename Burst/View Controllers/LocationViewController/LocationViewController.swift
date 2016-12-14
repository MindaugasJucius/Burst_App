import UIKit
import BurstAPI

fileprivate let LocationHeaderReuseID = "LocationHeader"

class LocationViewController: UIViewController {
    
    @IBOutlet weak fileprivate var tableView: UITableView!

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
        let nib = UINib(nibName: MapTableViewCell.className, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: LocationHeaderReuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        tableView.backgroundColor = AppAppearance.tableViewBackground
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 30
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.separatorStyle = .none

    }

    fileprivate func configure(headerView: UIView) {
        guard let header = headerView as? UITableViewHeaderFooterView else {
            return
        }
        header.contentView.backgroundColor = AppAppearance.tableViewBackground
        header.textLabel?.font = AppAppearance.regularFont(withSize: .sectionHeaderTitle)
        header.textLabel?.text = "\(location.city), \(location.country)"
        header.textLabel?.textColor = AppAppearance.gray666
    }
    
}

extension LocationViewController: PhotoInfoContentController {

    func contentHeight() -> CGFloat {
        return tableView.contentSize.height
    }

}

extension LocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: LocationHeaderReuseID)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        configure(headerView: view)
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
