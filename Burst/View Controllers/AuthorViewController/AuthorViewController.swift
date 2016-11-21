import UIKit

class AuthorViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "lol")
        tableView.dataSource = self
        tableView.bounces = false
    }

    func contentHeight() -> CGFloat {
        view.layoutIfNeeded()
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
}

extension AuthorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lol", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}
