import UIKit
import BurstAPI

fileprivate let DetailsCellReuseId = "DetailsCell"

class PhotoDetailsDataSource: NSObject {

    private weak var tableView: UITableView?
    private let fullPhoto: Photo
    
    fileprivate var photoInfoControllers: CorrespondingInfoControllers
    fileprivate let availableInfo: [PhotoInfoType]
    
    init(tableView: UITableView, photo: Photo, controllers: CorrespondingInfoControllers) {
        self.tableView = tableView
        self.photoInfoControllers = controllers
        self.availableInfo = photo.checkForAvailableInfo()
        self.fullPhoto = photo
        super.init()
        registerViews()
        
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
    
    func estimatedHeight(forRowAtPath rowPath: IndexPath) -> CGFloat {
        if availableInfo[rowPath.section] == .author {
            guard let controller = photoInfoControllers[.author] as? AuthorViewController else {
                return 44
            }
            return controller.contentHeight()
        }
        return 44
    }
    
    // MARK: - Configure reusable views
    
    func configure(header: TableViewHeaderWithButton, forSection section: Int) {
        let infoSection = availableInfo[section]
        let title = String(describing: availableInfo[section])
        if infoSection == .author {
            header.configure(
                labelTitle: title,
                hideButton: false,
                hideImage: false,
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
        let infoForSection = availableInfo[indexPath.section]
        if infoForSection == .author {
            guard let controllerForInfo = photoInfoControllers[infoForSection] else {
                return cell
            }
            controllerForInfo.view.frame = cell.bounds
            cell.contentView.insertSubview(controllerForInfo.view, at: 0)
        } else {
            cell.textLabel?.text = "\(infoForSection)"
        }
        return cell
    }
}
