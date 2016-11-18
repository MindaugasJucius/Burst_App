import UIKit
import BurstAPI

class PhotoDetailsDataSource: NSObject {

    private weak var tableView: UITableView?
    private let photo: Photo
    
    init(tableView: UITableView, photo: Photo) {
        self.tableView = tableView
        self.photo = photo
        super.init()
    }
}

extension PhotoDetailsDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCellReuseId, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
