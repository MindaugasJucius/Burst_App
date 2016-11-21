import UIKit
import BurstAPI

class PhotoViewControllerDataSource: NSObject {

    var didEndPanWithPositiveVelocity: (() -> ())?
    var didEndPanWithNegativeVelocity: (() -> ())?
    var didTapClosePhotoPreview: (() -> ())?
    
    private let dataController = PhotoDataController()
    private let photo: Photo
    
    private weak var tableView: UITableView?
    private weak var viewController: UIViewController?
    
    private var topImageSpacing: CGFloat = 0
    private var photoInfoControllers: CorrespondingInfoControllers = [:] {
        didSet {
            guard !photoInfoControllers.isEmpty else {
                return
            }
            addChildsToViewController()
        }
    }
    private var fullPhoto: Photo?
    private var contentHeight: CGFloat = 0

    init(tableView: UITableView, viewController: UIViewController, photo: Photo) {
        self.tableView = tableView
        self.viewController = viewController
        self.photo = photo
        super.init()
        dataController.fullPhoto(
            withID: photo.id,
            success: { [unowned self] retrievedPhoto, contentControllers in
                self.photoInfoControllers = contentControllers
                self.fullPhoto = retrievedPhoto
                let detailsPath = IndexPath(item: 1, section: 0)
                self.tableView?.reloadRows(at: [detailsPath], with: .none)
            },
            failure: { error in
                viewController.handle(error: error)
            }
        )
    }
    
    // MARK: - Private

    private func addChildsToViewController() {
        for (_, controller) in photoInfoControllers {
            viewController?.addChildViewController(controller)
            controller.didMove(toParentViewController: viewController)
            contentHeight += controller.view.frame.height
        }
    }
    
    // MARK: - Cell setup
    
    fileprivate func setup(photoCell: FullPhotoTableViewCell) -> FullPhotoTableViewCell {
        photoCell.photoImage = photo.thumbImage
        photoCell.topSpacing = topImageSpacing
        photoCell.backgroundColor = AppAppearance.tableViewBackground
        photoCell.didTapClosePhotoPreview = didTapClosePhotoPreview
        return photoCell
    }
    
    fileprivate func setup(photoDetailsCell: PhotoDetailsTableViewCell) -> PhotoDetailsTableViewCell {
        photoDetailsCell.isUserInteractionEnabled = false
        photoDetailsCell.parentTableView = tableView
        photoDetailsCell.photoInfoControllers = photoInfoControllers
        photoDetailsCell.photo = fullPhoto ?? photo
        photoDetailsCell.backgroundColor = AppAppearance.tableViewBackground
        photoDetailsCell.didEndPanWithPositiveVelocity = didEndPanWithPositiveVelocity
        photoDetailsCell.didEndPanWithNegativeVelocity = didEndPanWithNegativeVelocity
        return photoDetailsCell
    }
    
    // MARK: - Delegate helpers
    
    func cellHeight(forRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        if indexPath.row == 0 {
            guard let image = photo.thumbImage else {
                return screenSize.height
            }
            let rate = screenSize.width / image.size.width
            let trueImageheight = image.size.height * rate
            topImageSpacing = (screenSize.height - trueImageheight) / 2
            let trueCellHeight = topImageSpacing + trueImageheight
            return trueCellHeight
        }
        return UIScreen.main.bounds.height * 0.75
    }
    
}

extension PhotoViewControllerDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotoDetailsTableViewCell.reuseIdentifier,
                for: indexPath
            )
            guard let photoDetailsCell = cell as? PhotoDetailsTableViewCell else {
                return cell
            }
            return setup(photoDetailsCell: photoDetailsCell)
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FullPhotoTableViewCell.reuseIdentifier,
                for: indexPath
            )
            guard let fullPhotoCell = cell as? FullPhotoTableViewCell else {
                return cell
            }
            return setup(photoCell: fullPhotoCell)
        }
    }
}
