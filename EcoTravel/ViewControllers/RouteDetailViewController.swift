import UIKit
import MapKit

/**
 * View controller for the detailed schedule of the selected route
 * - author: Minji Choi
 * - since: 2021-04-24
 */
class RouteDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationText: UILabel!
    @IBOutlet weak var destinationTime: UILabel!
    @IBOutlet weak var originTime: UILabel!
    @IBOutlet weak var legsStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itineraryStackView: UIStackView!
    
    // receieve coordinates of origin and destination, the place name of the destination, and itinerary data from route suggestion view.
    var origin:CLLocationCoordinate2D?
    var destination:CLLocationCoordinate2D?
    var destinationTitle: String?
    var itinerary:Itineraries?
    let uiManager = UIManager()
    let routeSuggestionsManager = RouteSuggestionsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let origin = origin, let destination = destination, let destinationTitle = destinationTitle, let itinerary = itinerary {
            routeSuggestionsManager.makeAnnotation(mapView, origin, isOrigin: true, destTitle: destinationTitle)
            routeSuggestionsManager.makeAnnotation(mapView, destination, isOrigin: false, destTitle: destinationTitle)
            routeSuggestionsManager.makeRoute(mapView, origin, destination)
            routeSuggestionsManager.generateRoute(mapView, legs: itinerary.legs)
            destinationText.text = destinationTitle
            
            let startTime = routeSuggestionsManager.timeFormatter(time: (itinerary.legs[0].startTime))
            let arrivalTime = routeSuggestionsManager.timeFormatter(time: (itinerary.legs.last!.endTime))
            originTime.text = startTime
            originTime.setContentCompressionResistancePriority(.required, for: .horizontal)
            destinationTime.text = arrivalTime
            destinationTime.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            for leg in itinerary.legs {
                let modeName = leg.mode
                let fromPlace = leg.from.name
                let toPlace = leg.to.name
                let lineNum = leg.trip?.routeShortName
                let lineDestination = leg.trip?.tripHeadsign
                let startTime = routeSuggestionsManager.timeFormatter(time: leg.startTime)
                let endTime = routeSuggestionsManager.timeFormatter(time: leg.endTime)
                
                // basic stack view for a leg
                let legStackView = uiManager.generateStackView(axis: .horizontal, distribution: .fillProportionally, alignment: .center, spacing: 8)
                let modeTextLabel = UILabel()
                modeTextLabel.font = modeTextLabel.font.withSize(14.5)
                
                if (modeName != "WALK"){
                    let modeImgName = routeSuggestionsManager.setModeImgName(mode: modeName)
                    uiManager.generateImageView(imgName: modeImgName, superView: legStackView, mode: modeName, size:32)
                    modeTextLabel.text = "\(modeName) \(lineNum!) \(lineDestination!)"
                    
                    // text label for place name of the origin
                    let fromPlaceLabel = uiManager.generateBoldTextLabel(text: fromPlace, size: 18.0)
                    
                    // vertical stack view for line name origin place name
                    let modeTextStackView = uiManager.generateStackView(axis: .vertical, distribution: .equalSpacing, alignment: .fill, spacing: 6)
                    modeTextStackView.addArrangedSubview(fromPlaceLabel)
                    modeTextStackView.addArrangedSubview(modeTextLabel)
                    legStackView.addArrangedSubview(modeTextStackView)
                    legStackView.frame.size.width = 300
                    // text label for starting time
                    let startTimeLabel = uiManager.generateBoldTextLabel(text: startTime, size: 24.0)
                    
                    // stack view for starting time text, origin place name, and line name
                    let itineraryStackView = uiManager.generateStackView(axis: .horizontal, distribution: .equalCentering, alignment: .center, spacing:5)
                    itineraryStackView.addArrangedSubview(legStackView)
                    itineraryStackView.addArrangedSubview(startTimeLabel)
                    startTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                    // text label for ending time
                    let endtimeLabel = uiManager.generateBoldTextLabel(text: endTime, size: 24.0)
                    
                    // stack view for destination place name and image view
                    let toStackView = uiManager.generateStackView(axis: .horizontal, distribution: .fillProportionally, alignment: .center, spacing: 6)
                    
                    // image view for the destination place
                    uiManager.generateImageView(imgName: "circle.circle", superView: toStackView, mode: "", size: 32)
                    
                    let toPlaceLabel = uiManager.generateBoldTextLabel(text: toPlace, size: 18)
                    toStackView.addArrangedSubview(toPlaceLabel)
                    toStackView.frame.size.width = 300
                    
                    // stack view for toStackView and ending time text label
                    let destinationStackView = uiManager.generateStackView(axis: .horizontal, distribution: .equalCentering, alignment: .center, spacing: 5)
                    destinationStackView.addArrangedSubview(toStackView)
                    destinationStackView.addArrangedSubview(endtimeLabel)
                    endtimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
                    
                    legsStackView.addArrangedSubview(itineraryStackView)
                    legsStackView.addArrangedSubview(destinationStackView)
                    
                    destinationStackView.trailingAnchor.constraint(equalTo: legsStackView.trailingAnchor, constant: 0).isActive = true
                    itineraryStackView.trailingAnchor.constraint(equalTo: legsStackView.trailingAnchor, constant: 0).isActive = true
                } else {
                    let imgView = UIImageView()
                    imgView.image = UIImage(named: "LegLine")
                    imgView.frame.size.width = 32
                    imgView.frame.size.height = 32
                    legStackView.addArrangedSubview(imgView)
                    
                    let distance = Int(ceil(Double(leg.distance)))
                    var distanceInKm: Double
                    let legDuration = (Int(leg.endTime)!-Int(leg.startTime)!)/1000/60
                    
                    if (distance >= 1000) {
                        distanceInKm = Double(distance/1000)
                        modeTextLabel.text = "\(modeName) \(distanceInKm)km (\(legDuration)min)"
                    } else {
                        modeTextLabel.text = "\(modeName) \(distance)m (\(legDuration)min)"
                    }
                    legStackView.addArrangedSubview(modeTextLabel)
                    legsStackView.addArrangedSubview(legStackView)
                }
                legsStackView.setContentHuggingPriority(.required, for: .horizontal)
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: itineraryStackView.frame.height + 500)
    }
    
    // set color and with of polylines
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (overlay as? ModePolyline)?.color
        renderer.lineWidth = 5
        return renderer
    }
}
