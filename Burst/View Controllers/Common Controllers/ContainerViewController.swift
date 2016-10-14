import UIKit
import Photos
import BurstAPI

// progress viewa isvis i sita nukelt
// arba padaryt kad ant celiu rodytu progresa
protocol ContainerControllerDelegate: class {
    func photoPermissionsGranted() -> Bool
    func downloadPhoto(_ photo: Photo) //grazini success ir tada ta cele pakeicia savo busena ;]
}

extension ContainerControllerDelegate where Self: UIViewController { }

class ContainerViewController: UIViewController {

    fileprivate var contentViewController: UIViewController?
    fileprivate var photoSavingHelper: PhotoSavingHelper?
    
    fileprivate var progressViewPresented = false
    
    var delegate: NavigationControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let className = String(describing: PhotosTableViewController.self)
        
        let photosTableViewStoryboard = UIStoryboard.init(name: className, bundle: nil)
        guard let controller = photosTableViewStoryboard.instantiateViewController(withIdentifier: className) as? PhotosTableViewController else {
            return
        }
        controller.delegate = self
        contentViewController = controller
        
        photoSavingHelper = PhotoSavingHelper(controller: controller)
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.didMove(toParentViewController: self)
        navigationController?.viewControllers = [controller]
    }
    
    fileprivate func addPhotoToDownloadQueue(_ photo: Photo) {
        UnsplashPhotos.defaultInstance.addImageToQueueForDownload(photo,
            progressHandler: { [weak self] progress in
                self?.delegate?.update(withProgress: progress)
            },
            completion: { [weak self] response, photo in
                guard let strongSelf = self else {
                    return
                }
                switch response.result {
                case .success(let image):
                    strongSelf.save(imageToSave: image)
                case .failure(let error):
                    strongSelf.presentError(error as NSError)
                }
            }
        )
    }
    
    fileprivate func save(imageToSave image: UIImage) {
        guard let saveHelper = photoSavingHelper else {
            return
        }
        saveHelper.save(imageToSave: image)
    }
}

extension ContainerViewController {
    
    fileprivate func presentError(_ error: NSError) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: self.contentViewController,
            withError: error
        )
    }
}

extension ContainerViewController: ContainerControllerDelegate {

    func photoPermissionsGranted() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    func downloadPhoto(_ photo: Photo) {
        addPhotoToDownloadQueue(photo)
    }
    
}
