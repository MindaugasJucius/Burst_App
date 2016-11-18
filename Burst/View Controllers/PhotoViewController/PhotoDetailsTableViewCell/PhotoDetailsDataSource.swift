import UIKit
import BurstAPI

class PhotoDetailsDataSource: NSObject {

    private weak var tableView: UITableView?
    private var fullPhoto: Photo?
    fileprivate var availableInfo: [PhotoInfoType] = []

    private let dataController = PhotoDetailsDataController()
    
    init(tableView: UITableView, photo: Photo) {
        self.tableView = tableView
        super.init()
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
}

extension PhotoDetailsDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellReuseId, for: indexPath)
        cell.textLabel?.text = "\(availableInfo[indexPath.row])"
        return cell
    }
}
