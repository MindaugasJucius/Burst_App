import UIKit
import BurstAPI
import AlamofireImage

let SideInset: CGFloat = 15
let ControlHeight: CGFloat = 30

typealias PhotoCallback = (_ photo: Photo?) -> ()

class PhotoTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak private var loveButton: UIButton!
    @IBOutlet weak private var saveButton: UIButton!
    @IBOutlet weak private var addButton: UIButton!
    @IBOutlet weak private var photoImageView: UIImageView!
    
    @IBOutlet weak private var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var imageViewRightConstraint: NSLayoutConstraint!
    
    var onLoveButton: PhotoCallback?
    var onAddButton: PhotoCallback?
    var onSaveButton: PhotoCallback?
    
    private var displayPhoto: Photo?
    
    private let progressIndicatorView = CircularProgressView(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        imageViewLeftConstraint.constant = SideInset
        imageViewRightConstraint.constant = SideInset
        setupProgressView()
        setupButtons()
    }
    
    override func prepareForReuse() {
        photoImageView?.image = nil
        loveButton.setFAIcon(icon: .FAHeartO,
                             iconSize: AppAppearance.ButtonFAIconSize,
                             forState: .normal)
        loveButton.setFATitleColor(color: AppAppearance.white)
        progressIndicatorView.isHidden = false
        progressIndicatorView.alpha = 1
        progressIndicatorView.progress = 0
    }
    
    func configure(forPhoto photo: Photo) {
        displayPhoto = photo
        guard let image = photo.thumbImage else {
            return
        }
        photoImageView.af_setImage(
            withURL: photo.urls.regular,
            placeholderImage: image,
            progress: { [weak self] progress in
                self?.progressIndicatorView.progress = CGFloat(progress.fractionCompleted)
            },
            imageTransition: .custom(duration: 0.2,
                                     animationOptions: .transitionCrossDissolve,
                                     animations: { imageView, image in
                                        imageView.image = image
                                     },
                                     completion: { [weak self] finished in
                                        self?.hideProgressView()
                                     }
            ),
            runImageTransitionIfCached: false,
            completion: nil)
    }
    
    func hideProgressView() {
        progressIndicatorView.progress = 1
        UIView.animate(withDuration: 0.2,
                       animations: { [weak self] in
                           self?.progressIndicatorView.alpha = 0
                       },
                       completion: nil)
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
