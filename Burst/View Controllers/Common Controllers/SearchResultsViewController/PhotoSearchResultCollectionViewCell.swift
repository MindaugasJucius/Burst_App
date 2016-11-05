import BurstAPI
import AlamofireImage

class PhotoSearchResultCollectionViewCell: UICollectionViewCell, ReusableView {

    private let progressIndicatorView = CircularProgressView(frame: .zero)
    
    var downloadProgress: CGFloat {
        get {
            return progressIndicatorView.progress
        }
        set {
            progressIndicatorView.progress = newValue
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
        imageView.backgroundColor = AppAppearance.lightBlack
    }
    
    func configure(forPhoto photo: Photo) {
    imageView.af_setImage(
            withURL: photo.urls.small,
            progress: { [weak self] (progress: Progress) in
                self?.downloadProgress = CGFloat(progress.fractionCompleted)
            },
            imageTransition: .crossDissolve(0.3),
            runImageTransitionIfCached: false,
            completion: { [weak self] response in
                switch response.result {
                case .success(_):
                    self?.progressIndicatorView.alpha = 0
                case .failure(_):
                    self?.progressIndicatorView.alpha = 0
                    self?.imageView.backgroundColor = .white
                }
            }
        )
    }
    
    private func setupProgressView() {
        imageView.addSubview(progressIndicatorView)
        progressIndicatorView.frame = imageView.frame
        progressIndicatorView.backgroundColor = .clear
        progressIndicatorView.isUserInteractionEnabled = false
        progressIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func prepareForReuse() {
        progressIndicatorView.progress = 0
        progressIndicatorView.alpha = 1
        imageView.image = nil
    }

}
