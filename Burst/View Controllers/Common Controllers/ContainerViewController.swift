import UIKit
import Photos
import BurstAPI

protocol ContainerControllerDelegate: class {
    func photoPermissionsGranted() -> Bool
    func downloadPhoto(_ photo: Photo)
}

extension ContainerControllerDelegate where Self: UIViewController { }

class ContainerViewController: UIViewController {

    private var contentViewController: UIViewController?
    private var photoSavingHelper: PhotoSavingHelper?
    private var searchController: UISearchController!
    private var searchControllerContainer: UISearchContainerViewController!
    private var searchBarButton: UIBarButtonItem!
    private var burstTitleView: UIView!
    private var searchBar: UISearchBar!
    
    var delegate: NavigationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContentController()
        burstTitleView = navigationItem.titleView
        setupSearchBar()
    }
    
    func addContentController() {
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
    }
    
    // MARK: - Search bar handling
    
    private func setupSearchBar() {
        let className = SearchResultsViewController.className()
        let resultsController = SearchResultsViewController(nibName: className, bundle: nil)
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchResultsUpdater = resultsController
        searchBar = searchController.searchBar
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        AppAppearance.applyLightBlackStyle(forSearchBar: searchController.searchBar)
        navigationItem.rightBarButtonItem = searchBarButton
    }
    
    @objc func search() {
        showSearchBar()
    }
    
    func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButton(nil, animated: true)
        searchBar.becomeFirstResponder()
        UIView.fadeIn(view: searchBar, completion: nil)
    }
    
    fileprivate func hideSearchBar() {
        navigationItem.setRightBarButton(searchBarButton, animated: true)
        navigationItem.titleView = burstTitleView
        UIView.fadeIn(view: burstTitleView, completion: nil)
    }
    
    // MARK: - Photo download handling
    
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

extension ContainerViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}
