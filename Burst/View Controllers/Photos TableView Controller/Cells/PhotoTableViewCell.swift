import UIKit
import BurstAPI
import AlamofireImage

let ControlHeight: CGFloat = 30

typealias PhotoActionCallback = (_ photo: Photo?) -> ()

class PhotoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak private var loveButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    @IBOutlet weak private var addButton: UIButton!
    @IBOutlet weak private var photoImageView: UIImageView!
    
    @IBOutlet weak private var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewRightConstraint: NSLayoutConstraint!
    
    private let progressIndicatorView = CircularProgressView(frame: .zero)
    private var tapGesture: UITapGestureRecognizer!

    var onLoveButton: PhotoActionCallback?
    var onAddButton: PhotoActionCallback?
    var onSaveButton: PhotoActionCallback?
    var onImageViewTap: PhotoActionCallback?
    
    private weak var displayPhoto: Photo?
    
    var displayImage: UIImage? {
        get {
            return photoImageView.image
        }
        set {
            displayPhoto?.smallImage = newValue
            transition(image: newValue)
        }
    }
    
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
        backgroundColor = .clear
        setupProgressView()
        setupButtons()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        photoImageView.addGestureRecognizer(tapGesture)
        photoImageView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        photoImageView?.image = nil
        progressIndicatorView.progress = 0
        progressIndicatorView.alpha = 1
        loveButton.setFAIcon(icon: .FAHeartO,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.white)
    }
    
    @objc private func imageViewTapped() {
        onImageViewTap?(displayPhoto)
    }
    
    func configure(forPhoto photo: Photo) {
        displayPhoto = photo
        photoImageView.image = photo.presentationImage
    }
    
    private func transition(image: UIImage?) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                self?.progressIndicatorView.alpha = 0
                self?.photoImageView.image = image
            },
            completion: nil
        )
    }
    
    private func setupProgressView() {
        photoImageView.addSubview(progressIndicatorView)
        progressIndicatorView.frame = photoImageView.frame
        progressIndicatorView.backgroundColor = .clear
        progressIndicatorView.isUserInteractionEnabled = false
        progressIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func setupButtons() {
        loveButton.setFAIcon(icon: .FAHeartO,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.white)
        
        saveButton.setFAIcon(icon: .FACloudDownload,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        saveButton.setFATitleColor(color: AppAppearance.white)
        
        addButton.setFAIcon(icon: .FAPlusCircle,
                            iconSize: AppAppearance.ButtonFAIconSize,
                            forState: .normal)
        addButton.setFATitleColor(color: AppAppearance.white)
    }
    
    @IBAction func loveButtonTouched(_ sender: UIButton) {
        loveButton.setFAIcon(icon: .FAHeart,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.darkRed)
        onLoveButton?(displayPhoto)
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        onSaveButton?(displayPhoto)
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        onAddButton?(displayPhoto)
    }
    
}
