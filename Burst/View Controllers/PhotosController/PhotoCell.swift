import BurstAPI
import UIKit

class PhotoCell: ContentCell {

    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private var imageView: UIImageView?
    private var onTap: OnContentTap?
    
    override var dataSourceItem: Any? {
        didSet {
            guard let photo = dataSourceItem as? Photo else {
                return
            }
            configure(forPhoto: photo)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        let imageView = UIImageView(frame: bounds)
        addSubview(imageView)
        addSubview(activityIndicator)
        imageView.backgroundColor = AppAppearance.lightBlack
        imageView.fillSuperview()
        activityIndicator.fillSuperview()
        activityIndicator.hidesWhenStopped = true
        self.imageView = imageView
    }
    
    private func configure(forPhoto photo: Photo) {
        activityIndicator.startAnimating()
        imageView?.backgroundColor = photo.color
        imageView?.af_setImage(
            withURL: photo.url(forSize: .small),
            imageTransition: .crossDissolve(0.2),
            completion: { [unowned self] response in
                switch response.result {
                case .success(_):
                    self.activityIndicator.stopAnimating()
                    self.imageView?.image = response.result.value
                case .failure(let error):
                    AlertControllerPresenterHelper.sharedInstance.topController(presentError: error)
                    self.activityIndicator.stopAnimating()
                }
            }
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
}
