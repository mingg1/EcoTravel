// This view will appear when a route option in the list.
// Author: Minji Choi

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationText: UILabel!
    @IBOutlet weak var destinationTime: UILabel!
    @IBOutlet weak var originTime: UILabel!
    @IBOutlet weak var legsStackView: UIStackView!
    
    // receieve coordinates of origin and destination, the place name of the destination, and itinerary data from route suggestion view.
    var origin:CLLocationCoordinate2D?
    var destination:CLLocationCoordinate2D?
    var destinationTitle: String?
    var itinerary:Itineraries?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let origin = origin, let destination = destination, let destinationTitle = destinationTitle, let itinerary = itinerary {
            makeAnnotation(mapView, origin, isOrigin: true, destTitle: destinationTitle)
            makeAnnotation(mapView, destination, isOrigin: false, destTitle: destinationTitle)
            makeRoute(mapView, origin, destination)
            generateRoute(mapView, legs: itinerary.legs)
            destinationText.text = destinationTitle
  
            let startTime = timeFormatter(time: (itinerary.legs[0].startTime))
            let arrivalTime = timeFormatter(time: (itinerary.legs.last!.endTime))
            originTime.text = startTime
            destinationTime.text = arrivalTime
            destinationTime.setContentCompressionResistancePriority(.required, for: .horizontal)
            for leg in itinerary.legs {
                let modeName = leg.mode     // transportation's name (walk, bus, subway etc.)
                let fromPlace = leg.from.name
                let toPlace = leg.to.name
                let lineNum = leg.trip?.routeShortName
                let lineDestination = leg.trip?.tripHeadsign
                let startTime = timeFormatter(time: leg.startTime)
                let endTime = timeFormatter(time: leg.endTime)
                
                let stackView = generateStackView(axis: .horizontal, distribution: .fillProportionally, alignment: .center, spacing: 8)
                let modeTextLabel = UILabel()
                modeTextLabel.font = modeTextLabel.font.withSize(14.5)
                
                if (modeName != "WALK"){
                    let modeImgName = setModeImgName(mode: modeName)
                    generateImageView(imgName: modeImgName, superView: stackView, mode: modeName, size:32)
                    modeTextLabel.text = "\(modeName) \(lineNum!) \(lineDestination!)"
                    
                    // text label for place name of the origin
                    let fromPlaceLabel = generateBoldTextLabel(text: fromPlace, size: 18.0)
                   
                    // vertical stack view for line name origin place name
                    let modeTextStackView = generateStackView(axis: .vertical, distribution: .equalSpacing, alignment: .fill, spacing: 6)
                    modeTextStackView.addArrangedSubview(fromPlaceLabel)
                    modeTextStackView.addArrangedSubview(modeTextLabel)
                    stackView.addArrangedSubview(modeTextStackView)
                    stackView.widthAnchor.constraint(equalToConstant: 270).isActive = true
                    
                    // text label for starting time
                    let startTimeLabel = generateBoldTextLabel(text: startTime, size: 24.0)
                    
                    // stack view for starting time text, origin place name, and line name
                    let itineraryStackView = generateStackView(axis: .horizontal, distribution: .fill, alignment: .center, spacing:23)
                    itineraryStackView.addArrangedSubview(stackView)
                    itineraryStackView.addArrangedSubview(startTimeLabel)
                    
                    // text label for ending time
                    let endtimeLabel = generateBoldTextLabel(text: endTime, size: 24.0)
                    
                    // stack view for destination place name and image view
                    let toStackView = generateStackView(axis: .horizontal, distribution: .fillProportionally, alignment: .center, spacing: 6)
                    
                    // image view for the destination place
                    generateImageView(imgName: "pencil", superView: toStackView, mode: "", size: 32)
                    
                    let toPlaceLabel = generateBoldTextLabel(text: toPlace, size: 18)
                    toStackView.addArrangedSubview(toPlaceLabel)
                    toStackView.widthAnchor.constraint(equalToConstant: 270).isActive = true
                    
                    // stack view for toStackView and ending time text label
                    let destinationStackView = generateStackView(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 23)
                    destinationStackView.addArrangedSubview(toStackView)
                    destinationStackView.addArrangedSubview(endtimeLabel)

                    legsStackView.addArrangedSubview(itineraryStackView)
                    legsStackView.addArrangedSubview(destinationStackView)
                    
                   itineraryStackView.widthAnchor.constraint(equalTo: legsStackView.widthAnchor).isActive = true
                    destinationStackView.rightAnchor.constraint(equalTo: legsStackView.rightAnchor, constant: 0).isActive = true
                    itineraryStackView.rightAnchor.constraint(equalTo: legsStackView.rightAnchor, constant: 0).isActive = true
                } else {
                    let imgView = UIImageView()
                    imgView.image = UIImage(named: "LegLine")
                    imgView.frame.size.width = 32
                    imgView.frame.size.height = 32
                    stackView.addArrangedSubview(imgView)
                    let distance = Int(ceil(Double(leg.distance)))
                    var distanceInKm: Double
                    let legDuration = (Int(leg.endTime)!-Int(leg.startTime)!)/1000/60
                    
                    if (distance >= 1000) {
                        distanceInKm = Double(distance/1000)
                        modeTextLabel.text = "\(modeName) \(distanceInKm)km (\(legDuration)min)"
                    } else {
                        modeTextLabel.text = "\(modeName) \(distance)m (\(legDuration)min)"
                    }
                    stackView.addArrangedSubview(modeTextLabel)
                    legsStackView.addArrangedSubview(stackView)
                }
               legsStackView.setContentHuggingPriority(.required, for: .horizontal)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (overlay as? ModePolyline)?.color
        renderer.lineWidth = 5
        return renderer
    }
}
