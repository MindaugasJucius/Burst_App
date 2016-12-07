import BurstAPI

typealias CorrespondingInfoControllers = [PhotoInfoType: UIViewController]
typealias CorrespondingInfoViews = [PhotoInfoType: UIView]
typealias PhotoInfoCallback = (_ photo: Photo) -> ()

extension PhotoInfoType {
    
    var controllerTypeForInfo: UIViewController.Type? {
        switch self {
        case .author:
            return AuthorViewController.self
        case .location:
            return LocationViewController.self
        default:
            return nil
        }
    }
    
    var controllerForInfo: UIViewController? {
        return controllerTypeForInfo?.fromStoryboard()
    }
    
}

class PhotoDataController: NSObject {

    var infoViews: CorrespondingInfoViews = [:]
    var infoControllers: CorrespondingInfoControllers = [:]
    
    func fullPhoto(withID id: String,
                   success: @escaping PhotoInfoCallback,
                   failure: @escaping ErrorCallback) {
        UnsplashPhoto.photo(
            withID: id,
            success: { [unowned self] photo in
                self.infoControllers = self.controllers(forPhoto: photo)
                success(photo)
            },
            failure: failure
        )
    }
    
    func contentHeight(forInfoType infoType: PhotoInfoType) -> CGFloat {
        switch infoType {
        case .author:
            guard let authorController = infoControllers[infoType] as? AuthorViewController else {
                return TableViewCellDefaultHeight
            }
            return authorController.contentHeight()
        case .location:
            guard let locationController = infoControllers[infoType] as? LocationViewController else {
                return TableViewCellDefaultHeight
            }
            return locationController.contentHeight()
        default:
            return TableViewCellDefaultHeight
        }
    }
    
    private func controllers(forPhoto photo: Photo) -> CorrespondingInfoControllers {
        let photoInfo = photo.checkForAvailableInfo()
        var photoInfoControllersDict: CorrespondingInfoControllers = [:]
        photoInfo.forEach { [unowned self] photoInfoType in
            switch photoInfoType {
            case .author:
                guard let authorType = photoInfoType.controllerTypeForInfo as? AuthorViewController.Type,
                    let controller = authorType.instantiate(forPhotoDetails: true) else {
                        return
                }
                controller.user = photo.uploader
                photoInfoControllersDict[photoInfoType] = controller
                self.infoViews[photoInfoType] = controller.view
            case .location:
                guard let location = photo.location else {
                    return
                }
                let controller = LocationViewController(location: location)
                photoInfoControllersDict[photoInfoType] = controller
                self.infoViews[photoInfoType] = controller.view
            default:
                return
            }
        }
        return photoInfoControllersDict
    }
    
}
