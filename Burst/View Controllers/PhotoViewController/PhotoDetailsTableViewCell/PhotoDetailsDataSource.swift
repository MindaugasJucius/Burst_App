import UIKit
import BurstAPI

fileprivate let DetailsCellReuseId = "DetailsCell"

class PhotoDetailsDataSource: NSObject {

    private weak var tableView: UITableView?
    private let fullPhoto: Photo
    
    fileprivate let photoInfoViews: CorrespondingInfoViews
    fileprivate let availableInfo: [PhotoInfoType]
    
    init(tableView: UITableView, photo: Photo, correspondingViews: CorrespondingInfoViews) {
        self.tableView = tableView
        self.photoInfoViews = correspondingViews
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
    
    // MARK: - Configure reusable views
    
    func configure(headerView: UIView, forSection section: Int) {
        guard let header = headerView as? TableViewHeaderWithButton else {
            return
        }
        let infoSection = availableInfo[section]
        let title = String(describing: availableInfo[section])
        if infoSection == .author {
            header.configure(
                labelTitle: fullPhoto.uploader.name,
                showImage: true,
                buttonTitle: "follow",
                onButtonTap: {
                    
                }
            )
            header.image(withURL: fullPhoto.uploader.userProfileImage.medium)
        } else {
            header.configure(labelTitle: title)
            let font = AppAppearance.regularFont(withSize: .systemSizePlusOne, weight: .regular)
            header.label(font: font, textColor: AppAppearance.lightGray)
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
        cell.backgroundColor = AppAppearance.tableViewBackground
        let infoForSection = availableInfo[indexPath.section]
        if infoForSection == .author || infoForSection == .location {
            guard let viewForInfo = photoInfoViews[infoForSection] else {
                return cell
            }
            viewForInfo.frame = cell.bounds
            cell.contentView.insertSubview(viewForInfo, at: 0)
        } else {
            cell.textLabel?.text = "\(infoForSection)"
        }
        return cell
    }
}
