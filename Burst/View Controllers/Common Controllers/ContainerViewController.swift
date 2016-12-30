import UIKit
import Photos
import BurstAPI
import MJSlideMenu

protocol ContainerControllerDelegate: class {
    func downloadPhoto(_ photo: Photo)
}

typealias ContainedController = (title: String, controller: UIViewController)

class ContainerViewController: UIViewController {

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
        let currentController: OnCurrentController = { [unowned self] in
            guard let segment = self.slideMenu?.currentlyVisibleSegment else {
                return nil
            }
            let containedController = self.containedControllers.filter { $0.title == segment.title }
            return containedController.first?.controller
        }
        photoSavingHelper = PhotoSavingHelper(currentControllerClosure: currentController)
    }
    
    func createSegments() {
        slideMenu = MJSlideMenu.create(withParentVC: self)
        slideMenu?.menuBackgroundColor = AppAppearance.tableViewBackground
        slideMenu?.contentBackgroundColor = AppAppearance.tableViewBackground
        slideMenu?.menuTextColor = AppAppearance.gray666
        slideMenu?.menuTextColorSelected = AppAppearance.lightGray
        slideMenu?.indexViewColor = AppAppearance.lightGray
        containedControllers.forEach { [unowned self] controllerTuple in
            self.add(containedController: controllerTuple.controller, toSlideMenu: true)
        }
        let segments = containedControllers.map { controllerTuple in
            return Segment(title: controllerTuple.title, contentView: controllerTuple.controller.view)
        }
        slideMenu?.segments = segments
    }
    
    func add(containedController controller: UIViewController, toSlideMenu: Bool) {
        guard let slideMenu = slideMenu else {
            return
        }
        let controllersFrame = toSlideMenu ? slideMenu.frame : view.bounds
        addChildViewController(controller)
        controller.view.frame = controllersFrame
        if !toSlideMenu {
            view.addSubview(controller.view)
        }
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
        add(containedController: recentSearchesController, toSlideMenu: false)
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
            onController: presentedViewController,
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
