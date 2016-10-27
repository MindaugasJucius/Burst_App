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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    @objc func search() {
        
    }
    
    fileprivate func addPhotoToDownloadQueue(_ photo: Photo) {
        UnsplashImages.image(
            fromUrl: photo.urls.full,
            withDownloader: UnsplashImages.fullImageDownloader,
            progressHandler: { [weak self] fractionCompleted in
                self?.delegate?.update(withProgress: fractionCompleted)
            },
            success: { [weak self] image in
                self?.save(imageToSave: image)
            },
            failure: { [weak self] error in
                self?.presentError(error)
            }
        )
    }
    
    private func save(imageToSave image: UIImage) {
        guard let saveHelper = photoSavingHelper else {
            return
        }
        saveHelper.save(imageToSave: image)
    }
    
    private func presentError(_ error: Error) {
        AlertControllerPresenterHelper.sharedInstance.presentErrorAlert(
            onController: contentViewController,
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
