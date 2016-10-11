import UIKit
import BurstAPI

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var dataSource: PhotosControllerDataSource?
    fileprivate var blurredCell: PhotoCellCollectionViewCell?
    
    var delegate: ContainerControllerDelegate?
    fileprivate var gradient: CAGradientLayer?
    fileprivate let orange = UIColor.colorWithHexString("FD4340")
    fileprivate let velvet = UIColor.colorWithHexString("CE2BAE")
    
    fileprivate let some = UIColor.colorWithHexString("8D24FF")
    fileprivate let someColor = UIColor.colorWithHexString("23A8F9")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delaysContentTouches = false
        collectionView.infiniteScrollIndicatorStyle = .gray
        dataSource = PhotosControllerDataSource(collectionView: collectionView, viewController: self)
        collectionView.backgroundColor = UIColor.white
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        addGradientLayer()
        addTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLayer()
    }
    
    fileprivate func addGradientLayer() {
        guard let navigationController = navigationController else {
            print("no navbar")
            return
        }
        
        let gradient = CAGradientLayer(layer: navigationController.navigationBar.layer)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = navigationController.navigationBar.bounds
        gradient.colors = [some.CGColor, someColor.CGColor]
        gradient.locations = [NSNumber(value: 0.0 as Double), NSNumber(value: 1 as Double)]
        navigationController.navigationBar.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    
    fileprivate func animateLayer() {
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 4.0
        colorChangeAnimation.toValue = [someColor.CGColor, some.CGColor]
        colorChangeAnimation.autoreverses = true
        colorChangeAnimation.repeatCount = .infinity
        self.gradient?.add(colorChangeAnimation, forKey: "colorChange")
    }
    
    @objc fileprivate func tap(_ gesture: UITapGestureRecognizer) {
        dataSource?.clearCellBlur()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dataSource?.clearCellBlur()
    }
    
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Delegate
    
    func downloadPhoto(_ photo: Photo) {
        delegate?.downloadPhoto(photo)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

extension PhotosCollectionViewController: CHTCollectionViewDelegateWaterfallLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let dataSource = dataSource else { return CGSize.zero }
        let imageSize = dataSource.collectionViewItemSizeAtIndexPath(indexPath)
        
        return CGSize(width: imageSize.width, height: imageSize.height)
    }

}

