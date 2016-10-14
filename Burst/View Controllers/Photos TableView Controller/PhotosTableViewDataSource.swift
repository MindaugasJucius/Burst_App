import UIKit

class PhotosTableViewDataSource: NSObject {
    
    private weak var tableView: UITableView!
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        registerViews()
    }
    
    private func registerViews() {
        let cellNib = UINib.init(nibName: PhotoTableViewCell.className(), bundle: nil)
        let headerNib = UINib.init(nibName: PhotoHeader.className(), bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: PhotoTableViewCell.reuseIdentifier)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: PhotoHeader.reuseIdentifier)
    }
}

extension PhotosTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
}
