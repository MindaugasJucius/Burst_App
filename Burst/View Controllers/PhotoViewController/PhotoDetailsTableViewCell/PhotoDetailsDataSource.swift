import UIKit
import BurstAPI

fileprivate let DetailsCellReuseId = "DetailsCell"

class PhotoDetailsDataSource: NSObject {

    private weak var tableView: UITableView?
    private var fullPhoto: Photo?
    fileprivate var availableInfo: [PhotoInfoType] = []

    private let dataController = PhotoDetailsDataController()
    
    init(tableView: UITableView, photo: Photo) {
        self.tableView = tableView
        super.init()
        registerViews()
        dataController.fullPhoto(
            withID: photo.id,
            success: { [unowned self] retrievedPhoto in
                self.fullPhoto = retrievedPhoto
                self.availableInfo = retrievedPhoto.checkForAvailableInfo()
                self.tableView?.reloadData()
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
    }
    
    func registerViews() {
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: DetailsCellReuseId)
        let headerNib = UINib(nibName: TableViewHeaderWithButton.className, bundle: nil)
        tableView?.register(headerNib, forHeaderFooterViewReuseIdentifier: TableViewHeaderWithButton.reuseIdentifier)
    }
    
    // MARK: - Delegate helpers
    
    func header(forSection section: Int) -> UIView? {
        guard let header = tableView?.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderWithButton.reuseIdentifier) as? TableViewHeaderWithButton else {
            return .none
        }
        configure(header: header, forSection: section)
        return header
    }
    
    // MARK: - Configure reusable views
    
    func configure(header: TableViewHeaderWithButton, forSection section: Int) {
        let infoSection = availableInfo[section]
        let title = String(describing: availableInfo[section])
        if infoSection == .author {
            header.configure(
                labelTitle: title,
                hideButton: false,
                buttonTitle: "follow",
                onButtonTap: {
                    
                }
            )
        } else {
            header.configure(labelTitle: title)
        }
    }
}

extension PhotoDetailsDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return availableInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellReuseId, for: indexPath)
        cell.textLabel?.text = "\(availableInfo[indexPath.section])"
        return cell
    }
}
