import MapKit
import UIKit
import BurstAPI

class MapTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var location: Location?
    private var coordinateCenter: CLLocationCoordinate2D?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapImageView.isUserInteractionEnabled = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        activityIndicator.activityIndicatorViewStyle = .white
        mapImageView.backgroundColor = AppAppearance.lightBlack
        contentView.backgroundColor = AppAppearance.lightBlack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
    }
    
    // MARK: Configuration
    
    func configure(forLocation location: Location) {
        self.location = location
        activityIndicator.startAnimating()
        let options = snapshotOptions(forLocation: location)
        let snapshotter = MKMapSnapshotter(options: options)
        snapshot(withSnapshotter: snapshotter)
    }
    
    private func snapshot(withSnapshotter snapshotter: MKMapSnapshotter) {
        activityIndicator.startAnimating()
        snapshotter.start { [weak self] snapshot, error in
            guard let strongSelf = self else {
                return
            }
            strongSelf.activityIndicator.stopAnimating()
            guard let snapshot = snapshot else {
                return
            }
            strongSelf.mapImageView.image = snapshot.image
            strongSelf.addPin()
        }
    }
    
    private func addPin() {
        let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
        var pointOnMap = contentView.center
        pin.animatesDrop = false
        pointOnMap.x = pointOnMap.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
        pointOnMap.y = pointOnMap.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
        pin.frame.origin = pointOnMap
        contentView.addSubview(pin)
    }
    
    private func snapshotOptions(forLocation location: Location) -> MKMapSnapshotOptions {
        let snapshotOptions = MKMapSnapshotOptions()
        let coordinate = CLLocationCoordinate2D(
            latitude: location.position.latitude,
            longitude: location.position.longitude
        )
        coordinateCenter = coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 7, longitudeDelta: 7))
        snapshotOptions.region = region
        snapshotOptions.scale = UIScreen.main.scale
        let bounds = UIScreen.main.bounds
        snapshotOptions.size = CGSize(width: bounds.width, height: bounds.height * 0.25)
        return snapshotOptions
    }
    
}
