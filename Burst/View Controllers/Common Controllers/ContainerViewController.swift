import UIKit
import Photos
import BurstAPI
import MJSlideMenu

protocol ContainerControllerDelegate: class {
    func downloadPhoto(_ photo: Photo)
}

typealias ContainedController = (title: String, controller: UIViewController)

class ContainerViewController: UIViewController {

    private var contentViewController: UIViewController?
    private var photoSavingHelper: PhotoSavingHelper?
    private var searchController: UISearchController!
    private var searchBarButton: UIBarButtonItem!
    private var burstTitleView: UIView!
    private var searchBar: UISearchBar!
    
    fileprivate var searchResultsController: SearchResultsViewController?
    fileprivate var recentSearchesController: RecentSearchesViewController?
    
    var delegate: NavigationControllerDelegate?
    
    fileprivate let containedControllers: [ContainedController]
    fileprivate var slideMenu: MJSlideMenu?
    
    init(containedControllers: [ContainedController]) {
        self.containedControllers = containedControllers
        super.init(nibName: ContainerViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        burstTitleView = navigationItem.titleView
        setupSearchBar()
        createSegments()
    }
    
    func createSegments() {
        slideMenu = MJSlideMenu.create(withParentVC: self)
        slideMenu?.menuBackgroundColor = AppAppearance.tableViewBackground
        slideMenu?.contentBackgroundColor = AppAppearance.tableViewBackground
        slideMenu?.menuTextColor = AppAppearance.gray666
        slideMenu?.menuTextColorSelected = AppAppearance.lightGray
        slideMenu?.indexViewColor = AppAppearance.lightGray
        containedControllers.forEach { [unowned self] controllerTuple in
            self.add(containedController: controllerTuple.controller)
        }
        let segments = containedControllers.map { controllerTuple in
            return Segment(title: controllerTuple.title, contentView: controllerTuple.controller.view)
        }
        slideMenu?.segments = segments
    }
    
    private func addContentController() {
        guard let controller = PhotosTableViewController.fromStoryboard() else {
            return
        }
        controller.delegate = self
        contentViewController = controller
        
        photoSavingHelper = PhotoSavingHelper(controller: controller)
        add(containedController: controller)
    }
    
    private func add(containedController controller: UIViewController) {
        guard let slideMenu = slideMenu else {
            return
        }
        addChildViewController(controller)
        controller.view.frame = slideMenu.frame
        controller.didMove(toParentViewController: self)
    }
    
    private func remove(containedController controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    // MARK: - Search bar handling
    
    private func setupSearchBar() {
        let resultsController = SearchResultsViewController(searchType: .photos, navController: self.navigationController)
        resultsController.onSearchOccurence = { [weak self] query in
            self?.recentSearchesController?.insert(query: query)
        }
        self.searchResultsController = resultsController
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchResultsUpdater = resultsController
        searchBar = searchController.searchBar
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        AppAppearance.applyLightBlackStyle(forSearchBar: searchController.searchBar)
        navigationItem.rightBarButtonItem = searchBarButton
    }
    
    @objc func showSearchBar() {
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButton(nil, animated: true)
        searchBar.becomeFirstResponder()
        let recentSearchesController = RecentSearchesViewController()
        recentSearchesController.onSearchQuerySelect = { [weak self] query in
            self?.searchBar.text = query
        }
        self.recentSearchesController = recentSearchesController
        add(containedController: recentSearchesController)
        
        UIView.fadeIn(view: searchBar, completion: nil)
    }
    
    fileprivate func hideSearchBar() {
        guard let child = childViewControllers.last, childViewControllers.count > 1 else {
            return
        }
        remove(containedController: child)
        navigationItem.setRightBarButton(searchBarButton, animated: true)
        navigationItem.titleView = burstTitleView
        UIView.fadeIn(view: burstTitleView, completion: nil)
    }
    
    // MARK: - Photo download handling
    
    fileprivate func addPhotoToDownloadQueue(_ photo: Photo) {
        UnsplashImages.image(
            fromUrl: photo.url(forSize: .full),
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
    
    func downloadPhoto(_ photo: Photo) {
        addPhotoToDownloadQueue(photo)
    }
}

extension ContainerViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}
