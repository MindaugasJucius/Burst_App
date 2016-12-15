import BurstAPI
import Unbox
import AlamofireImage

struct ImageDTO {
    let imageDownloadUrl: URL
    let placeholderColor: UIColor
    
    init(imageDownloadUrl: URL, placeholderColor: UIColor = UIColor.white) {
        self.imageDownloadUrl = imageDownloadUrl
        self.placeholderColor = placeholderColor
    }
}

class ImageViewCollectionViewCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private let progressIndicatorView = CircularProgressView(frame: .zero)
    
    var downloadProgress: CGFloat {
        get {
            return progressIndicatorView.progress
        }
        set {
            progressIndicatorView.progress = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProgressView()
    }
    
    func configure(withAny any: Any) {
        guard let imageDTO = any as? ImageDTO else {
            return
        }
        configure(forImageDTO: imageDTO)
    }
    
    func configure(forImageDTO imageDTO: ImageDTO) {
        imageView.backgroundColor = imageDTO.placeholderColor
        imageView.af_setImage(
            withURL: imageDTO.imageDownloadUrl,
            progress: { [weak self] (progress: Progress) in
                self?.downloadProgress = CGFloat(progress.fractionCompleted)
            },
            imageTransition: .crossDissolve(0.3),
            runImageTransitionIfCached: false,
            completion: { [weak self] response in
                switch response.result {
                case .success(_):
                    self?.progressIndicatorView.alpha = 0
                    let image = response.result.value
                    self?.imageView.image = image
                    //imageDTO.image = response.result.value
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

extension Photo {
    func imageDTO(withSize photoSize: PhotoSize) -> ImageDTO {
        return ImageDTO(imageDownloadUrl: url(forSize: photoSize), placeholderColor: color)
    }
}
