import UIKit
import Photos
import BurstAPI

// progress viewa isvis i sita nukelt
// arba padaryt kad ant celiu rodytu progresa
protocol ContainerControllerDelegate: class {
    func photoPermissionsGranted() -> Bool
    func downloadPhoto(photo: Photo) //grazini success ir tada ta cele pakeicia savo busena ;]
}

extension ContainerControllerDelegate where Self: UIViewController { }

protocol ContainerAlerts { }

class ContainerViewController: UIViewController {

    private var contentViewController: UIViewController?
    private var photoSavingHelper: PhotoSavingHelper?
    
    private var progressViewPresented = false
    
    override func viewWillAppear(animated: Bool) {
        //settingsStoreGetPreferredVC
        let controller = PhotosCollectionViewController(nibName: "PhotosCollectionViewController", bundle: nil)
        contentViewController = controller
        controller.delegate = self
        photoSavingHelper = PhotoSavingHelper(controller: controller)
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMoveToParentViewController(self)
        navigationController?.viewControllers = [controller]
    }
    
    private func addPhotoToDownloadQueue(photo: Photo) {
        UnsplashPhotos.defaultInstance.addImageToQueueForDownload(photo,
            progressHandler: { (progress) in

            },
            completion: { [weak self] response, photo in
                guard let strongSelf = self else {
                    return
                }
                switch response.result {
                case .Success(let image):
                    strongSelf.save(imageToSave: image)
                case .Failure(let error):
                    strongSelf.presentError(error)
                }
            }
        )
    }
    
    private func save(imageToSave image: UIImage) {
        guard let saveHelper = photoSavingHelper else {
            return
        }
        saveHelper.save(imageToSave: image)
    }
}

extension ContainerViewController: ContainerAlerts {
    
    private func presentError(error: NSError) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: self.contentViewController,
            withError: error
        )
    }
}

extension ContainerViewController: ContainerControllerDelegate {

    func photoPermissionsGranted() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .Authorized
    }
    
    func downloadPhoto(photo: Photo) {
        addPhotoToDownloadQueue(photo)
    }
    
}
