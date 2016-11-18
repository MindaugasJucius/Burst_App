import UIKit
import BurstAPI

class PhotoViewControllerDataSource: NSObject {

    private weak var tableView: UITableView?
    private let photo: Photo
    private var topImageSpacing: CGFloat = 0
    
    var didEndPanWithPositiveVelocity: (() -> ())?
    var didEndPanWithNegativeVelocity: (() -> ())?
    var didTapClosePhotoPreview: (() -> ())?
    
    init(tableView: UITableView, photo: Photo) {
        self.tableView = tableView
        self.photo = photo
        super.init()
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
        photoDetailsCell.photo = photo
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
        return screenSize.height * 0.75
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
