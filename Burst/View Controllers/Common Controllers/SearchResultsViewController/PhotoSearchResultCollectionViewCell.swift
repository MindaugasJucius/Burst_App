import BurstAPI
import AlamofireImage

class PhotoSearchResultCollectionViewCell: UICollectionViewCell {

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
    }
    
    func configure(forPhoto photo: Photo) {
    imageView.af_setImage(
            withURL: photo.urls.thumb,
            progress: { [weak self] (progress: Progress) in
                self?.downloadProgress = CGFloat(progress.fractionCompleted)
            },
            imageTransition: .crossDissolve(0.3),
            runImageTransitionIfCached: false,
            completion: { [weak self] response in
                switch response.result {
                case .success(_):
                    self?.progressIndicatorView.removeFromSuperview()
                case .failure(_):
                    self?.progressIndicatorView.removeFromSuperview()
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

}
